{{
  config(
    materialized = "table",
    tags = ["data_quality", "mart", "07_02_vat_quality", "check_kkm"],
    description = "Ошибки ставок НДС в документах Чек ККМ",
    meta = {
        "owner": "data_engineering",
        "layer": "mart",
        "source": "enriched",
        "project": "07_02_vat_quality"
        }
    )
}}

select
    partition_day,
    doc_date,
    doc_name,
    doc_type,
    doc_status,
    partner_key,
    partner_name,
    warehouse_name,
    cashier_name,
    organization_name,
    division_name,
    seller_name,
    organization_vat_rate_current,
    product_rate_vat,
    sale_rate_vat,
    case
        -- Правило 1: Если ставка НДС не найдена по любому из полей, то ошибка
        when organization_vat_rate_current is null 
            then '1а.Организация не найдена в справочнике'
        when product_rate_vat is null 
            then '1б.Товар не найден в справочнике'
        when sale_rate_vat is null 
            then '1в.Ставка НДС продажи не указана'
        -- Правило 2: Если льготная ставка НДС номенклатуры не соответствует льготной ставке НДС продажи при общей ставке НДС организации, то ошибка
        when product_rate_vat = 10
            and organization_vat_rate_current = 22 
            and sale_rate_vat != 10 
            then '2.Ставка НДС продажи не соответствует льготной ставке НДС товара'
        -- Правило 3: Если ставка НДС продажи не соответствует ставке НДС организации, то ошибка
        when organization_vat_rate_current != sale_rate_vat 
            then '3.Ставка НДС продажи не соответствует ставке НДС организации'
        else 
            null
    end as kkm_error_description,
    is_posted,
    is_goods_row_exists,
    navigation_link,
    exported_at_doc,
    exported_at_goods,
    prepared_at,
    now() as exported_errors_at
from {{ ref('int_07_02_check_kkm_enriched') }}
where 
    is_goods_row_exists = true
    and doc_status = 'Чек пробит'
    and is_posted = true
    and toDate(doc_date) >= '2026-01-01'
    -- Фильтруем заведомо правильные записи
    and not (organization_vat_rate_current = 5 and sale_rate_vat = 5) 
    and not (product_rate_vat = 10 and sale_rate_vat = 10 and organization_vat_rate_current = 22)
    and not (sale_rate_vat = 22 and organization_vat_rate_current = 22)
    -- добавить другие "правильные" комбинации и перенести в CTE, чтобы не дублировать в разных местах
{# having kkm_error_description is not null # }


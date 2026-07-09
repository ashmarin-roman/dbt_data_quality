{{
  config(
    materialized = 'view',
    tags = ["check_kkm", "intermediate", "enriched", '07_02'],
    description = 'Обобогащенный документ Чек ККМ данными из справочников (Организации, Номенклатура, Пользователи 1С)',
    meta = {
        "owner": "data_engineering",
        "quality": "silver",
        "source": "check_kkm",
        "target": "enriched",
        "project": "07_02_vat_quality"
        }

    )
}}

select
    ck_p.doc_date AS doc_date,
    ck_p.doc_name AS doc_name,
    ck_p.doc_status AS doc_status,
    ck_p.is_posted AS is_posted,
    ck_p.partner_key AS partner_key,
    ck_p.partner_name AS partner_name,
    ck_p.warehouse_name AS warehouse_name,
    ck_p.organization_uid AS organization_uid,
    ck_p.cashier_name AS cashier_name,
    ck_p.navigation_link AS navigation_link,
    ck_p.doc_uid AS doc_uid,
    ck_p.doc_type AS doc_type,
    ck_p.partition_day AS partition_day,
    ck_p.seller_name AS seller_name,
    ck_p.product_uid AS product_uid,
    ck_p.sale_rate_vat AS sale_rate_vat,
    ck_p.is_goods_row_exists AS is_goods_row_exists,
    ck_p.exported_at_doc AS exported_at_doc,
    ck_p.exported_at_goods AS exported_at_goods,
    ck_p.prepared_at AS prepared_at,
    d_org.organization_name AS organization_name,
    d_org.vat_rate_2025 AS organization_vat_rate_2025,
    d_org.vat_rate_current AS organization_vat_rate_current,
    d_prod.rate_vat AS product_rate_vat,
    d_user.division_name AS division_name
from {{ ref('int_check_kkm_prepared') }} AS ck_p 
    left join {{ ref('stg_bronze__dim_organization') }} AS d_org
        ON ck_p.organization_uid = d_org.organization_uid
    left join {{ ref('stg_bronze__dim_product') }} AS d_prod
        ON ck_p.product_uid = d_prod.product_uid
    left join {{ ref('stg_bronze__dim_user_1c') }} AS d_user
        ON ck_p.seller_uid = d_user.user_1c_uid


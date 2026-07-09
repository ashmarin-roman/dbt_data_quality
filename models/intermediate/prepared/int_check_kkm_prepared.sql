{{ config(
    materialized = "table",
    tags = ["check_kkm", "intermediate", "prepared"],
    description = "Подготовленный документ Чек ККМ (шапка + товары + метаданные)",
    meta = {
        "owner": "data_engineering",
        "quality": "bronze",
        "source": "check_kkm",
        "target": "prepared",
        "project": "07_data_quality"
    }
) 
}}


select
  ck_h.doc_date,
  ck_h.doc_name,
  ck_h.doc_status,
  ck_h.is_posted,
  ck_h.partner_key,
  ck_h.partner_name,
  ck_h.warehouse_name,
  ck_h.organization_uid,
  ck_h.cashier_name,
  ck_h.cashier_uid,
  ck_h.navigation_link,
  ck_h.doc_uid,
  ck_h.doc_type,
  ck_h.partition_day,
  ch_tg.seller_name,
  ch_tg.seller_uid,
  ch_tg.product_uid,
  ch_tg.rate_vat AS sale_rate_vat,
  ch_tg.product_key IS NOT NULL AS is_goods_row_exists,
  ck_h.exported_at AS exported_at_doc,
  ch_tg.exported_at AS exported_at_goods,
  now() AS prepared_at

from
    {{ ref('stg_bronze__doc_check_kkm_header') }} AS ck_h 
        FULL JOIN {{ ref('stg_bronze__doc_check_kkm_tab_goods') }} AS ch_tg
        ON ck_h.doc_uid = ch_tg.doc_uid
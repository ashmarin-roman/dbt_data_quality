{{
  config(
    materialized = 'view',
    tags = ['bronze', 'staging'],
    description = """
      Стадия Bronze (staging). Отбор полей табличной части (товары) документов Чек ККМ.
      Включает rate_vat по строкам — ключевой атрибут для выявления некорректных ставок НДС.""",
    meta = {
        'owner': 'data_engineering',
        'project': '07_02_vat_quality'
           }
    )
}}

select
  doc_name,
  {# tab_line_number, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# tabs_link_key, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# product_name, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# Upakovka, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  {# KolichestvoUpakovok, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  {# product_count, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# product_price, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# sale_sum, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# sum_vat, #} {# FUTURE: добавить в источники, по мере необходимости #}
  rate_vat,
  {# ProtsentAvtomaticheskoySkidki, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  {# SummaAvtomaticheskoySkidki, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  {# ProtsentRuchnoySkidki, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  {# SummaRuchnoySkidki, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  seller_name,
  {# SummaBonusnykhBallovKSpisaniyu, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  {# SummaBonusnykhBallovKSpisaniyuVValyute, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  {# SummaNachislennykhBonusnykhBallovVValyute, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  {# NomenklaturaNabora, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  {# SHtrikhkod, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  {# IdentifikatorStroki, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  {# Komitent, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  product_key,
  date,
  partition_day,
  doc_uid,
  product_uid,
  {# seller_uid, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# project_id, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# db_type, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# db_name, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# doc_name_for_04_sales, #} {# FUTURE: добавить в источники, по мере необходимости #}
  exported_at

from {{ source('bronze', 'doc_check_kkm_tab_goods') }}
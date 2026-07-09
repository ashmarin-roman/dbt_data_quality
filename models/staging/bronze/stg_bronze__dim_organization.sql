{{
  config(
    materialized = 'view',
    tags = ['bronze', 'staging'],
    description = """
      Стадия Bronze (staging). Минимальная очистка и отбор полей справочника организаций из сырых данных 1С.
      Содержит ключевые атрибуты, включая ставки НДС организации.""",
    meta = {
        'owner': 'data_engineering',
        'project': '07_data_quality'
           }
    )
}}

select
  organization_name,
  {# organization_inn, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# organization_kpp, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# organization_ogrn, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# organization_prefiks, #} {# FUTURE: добавить в источники, по мере необходимости #}
  organization_status,
  {# created_at, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# legal_type, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# is_deleted, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# project_id, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# db_name, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# navigation_link, #} {# FUTURE: добавить в источники, по мере необходимости #}
  vat_rate_2025,
  vat_rate_current,
  organization_uid,
  exported_at

from {{ source('bronze', 'dim_organization') }}

    
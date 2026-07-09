{{
  config(
      materialized = 'view',
      tags = ['bronze', 'staging', "check_kkm"],
      description = """
        Стадия Bronze (staging). Отбор полей шапки документов Чек ККМ из сырых данных 1С.
        Подготовка для объединения с табличной частью и дальнейшего анализа ошибок ставок НДС.""",
      meta = {
          'owner': 'data_engineering',
          'project': '07_data_quality'
             }
        )
}}

SELECT
  doc_date,
  doc_name,
  doc_status,
  is_posted,
  {# doc_sum, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# doc_comment, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# division_name, #} {# FUTURE: добавить в источники, по мере необходимости #}
  partner_key,
  partner_name,
  warehouse_name,
  {# warehouse_uid, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# organization, #} {# FUTURE: добавить в источники, по мере необходимости #}
  organization_uid,
  cashier_name,
  cashier_uid,
  exported_at,
  navigation_link,
  doc_uid,
  doc_type,
  partition_day,
  {# NalogooblozhenieNDS, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  {# TSenaVklyuchaetNDS #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}

FROM {{ source('bronze', 'doc_check_kkm_header') }}



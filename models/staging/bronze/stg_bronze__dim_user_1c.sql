{{ config(
    materialized = 'view',
    tags = ['bronze', 'staging'],
    description = """
      Стадия Bronze (staging). Минимальная очистка справочника пользователей 1С (сотрудников).
      Содержит ФИО, подразделение и мотивацию для обогащения данных по ответственным в документах.""",
    meta = {
        'owner': 'data_engineering',
        'project': '07_data_quality'
           }
      ) 
}}

select
  user_1c_name,
  employee_name,
  employee_motivation,
  division_name,
  {# user_1c_comment, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# is_no_active, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# is_deleted, #} {# FUTURE: добавить в источники, по мере необходимости #}
  user_1c_uid,
  {# Sluzhebnyy, #} {# FUTURE: добавить в источники, по мере необходимости #}
  {# Podgotovlen, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  {# IdentifikatorPolzovatelyaIB, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  {# IdentifikatorPolzovatelyaServisa, #} {# FUTURE: стандартизировать название + добавить в источники, по мере необходимости #}
  exported_at

from {{ source('bronze', 'dim_user_1c') }}


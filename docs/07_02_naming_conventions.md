# 07.02 — Соглашения по именованию моделей

## Общие принципы

- Имена моделей должны быть **понятными** и **самодокументируемыми**.
- Используем префиксы, отражающие слой и тип объекта.
- Используем суффиксы, описывающие этап обработки данных (`_prepared`, `_enriched`, `_errors`)
- Для источников данных, при получении табличных частей объектов, используется дополнительный суффикс `_tab`. Пример: `stg_bronze__doc_check_kkm_tab_goods.sql`
- Избегаем избыточных префиксов (например, код проекта `07`), если контекст уже есть в структуре папок.
- Код подпроекта (`07_02`) оставляем только там, где это необходимо для контекста (в enriched и mart), т.к. prepared — общий слой.
- Разделяем документы (`doc_`) и справочники (`dim_`).


## Правила именования по слоям

### 1. Staging (bronze)

**Формат:** `stg_bronze__<тип>_<название_объекта>__<header|tab_goods>`

**Примеры:**
- `stg_bronze__doc_check_kkm_header.sql`
- `stg_bronze__doc_check_kkm_tab_goods.sql`
- `stg_bronze__doc_sale_doc_header.sql`
- `stg_bronze__doc_refund_sale_doc_header.sql`
- `stg_bronze__dim_organization.sql`
- `stg_bronze__dim_employee.sql`
- `stg_bronze__dim_product.sql`

### 2. Intermediate → Prepare (Этап 2)

**Формат:** `int_<название_документа>_prepared`

**Примеры:**
- `int_check_kkm_prepared.sql`
- `int_sale_doc_prepared.sql`
- `int_refund_sale_doc_prepared.sql`
- `int_payment_card_operation_prepared.sql`


### 3. Intermediate → Enriched (Этап 3)

**Формат:** `int_07_02_<название_документа>_enriched`

**Примеры:**
- `int_07_02_check_kkm_enriched.sql`
- `int_07_02_sale_doc_enriched.sql`
- `int_07_02_refund_sale_doc_enriched.sql`

### 4. Marts  (Этап 4)

**Формат:** `mart_07_02_<название_документа>_errors`

**Примеры:**
- `mart_07_02_check_kkm_errors.sql`
- `mart_07_02_sale_doc_errors.sql`
- `mart_07_02_refund_sale_doc_errors.sql`

### 5. Marts. Витрина ошибок, общая для подпроекта 07_02 (Этап 5)

**Формат:** `mart_07_02_all_errors`


### 6. Marts. Финальная витрина ошибок (Этап 6)

**Формат:** `mart_all_errors`


## Сводная таблица

| Слой                    | Папка (в `models`)             | Префикс                | Пример имени модели                    | Материализация |
|-------------------------|--------------------------------|------------------------|----------------------------------------|----------------|
| Staging                 | `staging/bronze/`              |`stg_bronze__`          | `stg_bronze__doc_check_kkm_header.sql` | view           |
| Prepare                 | `intermediate/prepared/`       |`int_`                  | `int_check_kkm_prepared.sql`           | table          |
| Enriched                | `intermediate/enriched/07_02/` |`int_07_02_`            | `int_07_02_check_kkm_enriched.sql`     | view           |
| Errors                  | `marts/data_quality/07_02/`    |`mart_07_02_`           | `mart_07_02_check_kkm_errors.sql`      | table          |
| All Errors (subproject) | `marts/data_quality/07_02/`    |`mart_07_02_all_errors` | `mart_07_02_all_errors.sql`            | view           |
| All Errors              | `marts/data_quality/`          |`mart_all_errors`       | `mart_all_errors.sql`                  | view           |


## Дополнительные правила

- В именах используем **английский** (check_kkm, sale_doc, refund и т.д.).
- Для документов используем префикс `doc_`, для справочников — `dim_`.
- Не используем коды подпроектов (`_yy_`) в именах общих моделей.


## Планы по развитию соглашений

- Перейти на единый стандарт именования dbt с использованием double underscore (__) для лучшей читаемости (например, `int_check_kkm__prepared`).
- Если в будущем появится необходимость в нескольких независимых dbt-проектах, можно рассмотреть добавление префикса проекта (например `bronze_07`).


---

**Автор:** Роман Ашмарин 
**Версия файла наименований:** v4
**Дата актуализации:** 09.07.2026
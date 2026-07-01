# 07.02 — Ошибки ставок НДС (Data Quality)

## 1. Цель подпроекта
Выявление документов продажи, оплаты и возвратов с некорректными ставками НДС.

## 2. Архитектура преобразований (5 этапов)

| Этап | Название слоя                                    | Тип материализации    | Описание                                                                  |
|------|--------------------------------------------------|-----------------------|---------------------------------------------------------------------------|
| 1    | `staging/bronze`                                 | `view`                | Минимальная очистка сырых данных (только отбор колонок)                   |
| 2    | `intermediate/07_02/prepare`                     | `table` + incremental | Фильтрация + объединение шапки и товаров под конкретный тип документа     |
| 3    | `intermediate/07_02/enriched`                    | `view`                | Обогащение данными из справочников (Организация, Сотрудник, Номенклатура) |
| 4    | `marts/data_quality/07_02/errors`                | `table`               | Расчёт ошибок по каждому типу документа (отдельные mart'ы)                |
| 5    | `marts/data_quality/07_02/mart_07_02_all_errors` | `view`                | Объединение всех ошибок проекта 07.02                                     |

## 3. Структура моделей

### Staging (Bronze)
- `stg_bronze__check_kkm_header.sql`
- `stg_bronze__check_kkm_goods.sql`
- `stg_bronze__sale_doc_header.sql`
- `stg_bronze__sale_doc_goods.sql`
- ... (аналогично для остальных документов и справочников)

### Intermediate → Prepare (Этап 2)
- `int_07_02_check_kkm_prepared.sql`
- `int_07_02_sale_doc_prepared.sql`
- `int_07_02_retail_sale_report_prepared.sql`
- `int_07_02_customer_order_prepared.sql`
- `int_07_02_refund_sale_doc_prepared.sql`
- `int_07_02_payment_card_operation_prepared.sql`
- `int_07_02_incoming_cash_order_prepared.sql`

### Intermediate → Enriched (Этап 3)
- `int_07_02_check_kkm_enriched.sql`
- `int_07_02_sale_doc_enriched.sql`
- ... (по аналогии)

### Marts → Errors (Этап 4)
- `mart_07_02_check_kkm_errors.sql`
- `mart_07_02_sale_doc_errors.sql`
- `mart_07_02_retail_sale_report_errors.sql`
- `mart_07_02_customer_order_errors.sql`
- `mart_07_02_refund_sale_doc_errors.sql`
- `mart_07_02_payment_card_operation_errors.sql`
- `mart_07_02_incoming_cash_order_errors.sql`

### Финальная витрина (Этап 5)
- `mart_07_02_all_errors.sql` — view с `UNION ALL` всех ошибок

## 4. Правила именования

- `stg_bronze__<документ>__<header|goods>`
- `int_07_02_<документ>_prepared`
- `int_07_02_<документ>_enriched`
- `mart_07_02_<документ>_errors`
- `mart_07_02_all_errors`

## 5. Принципы архитектуры

- Максимальная изоляция по типам документов на уровне `prepare` и `errors`.
- Обогащение (`enriched`) делается view, чтобы не дублировать данные при изменении справочников.
- Расчёт ошибок вынесен в отдельные mart-модели (можно пересчитывать независимо).
- Финальная витрина — лёгкая view.

## 6. Ограничения по данным (из описания проекта)

- Дата документа ≥ 2026-01-01 (кроме возвратов)
- Только проведённые документы
- Чек ККМ — только статус "Чек пробит"
- Номенклатура — только льготные ставки НДС (10%, 10/110)

---

**Автор:** Роман Ашмарин 
**Дата актуализации:** 26.06.2026
**Версия файла описания:** v1
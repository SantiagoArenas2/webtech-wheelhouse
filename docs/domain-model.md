# Domain model

## Diagram

![Domain model](domain-model.svg)

## DBML code

```dbml
Table customers {
  id int [pk, increment]
  full_name varchar [not null]
  phone varchar [not null]
  created_at datetime
  updated_at datetime
}

Table staff_members {
  id int [pk, increment]
  full_name varchar [not null]
  role varchar [not null]
  created_at datetime
  updated_at datetime
}

Table bikes {
  id int [pk, increment]
  customer_id int [ref: > customers.id, not null]
  brand varchar [not null]
  model varchar [not null]
  serial_number varchar [unique, not null]
  created_at datetime
  updated_at datetime
}

Table price_lists {
  id int [pk, increment]
  year int [unique, not null]
  effective_from date [not null]
  effective_to date
  created_at datetime
  updated_at datetime
}

Table service_catalogue_items {
  id int [pk, increment]
  price_list_id int [ref: > price_lists.id, not null]
  name varchar [not null]
  list_price decimal [not null]
  created_at datetime
  updated_at datetime

  Indexes {
    (price_list_id, name) [unique]
  }
}

Table repair_jobs {
  id int [pk, increment]
  bike_id int [ref: > bikes.id, not null]
  customer_id int [ref: > customers.id, not null]
  received_by_staff_id int [ref: > staff_members.id, not null]
  promised_by date
  status varchar [not null, default: `received`]
  received_at datetime [not null]
  ready_at datetime
  picked_up_at datetime
  created_at datetime
  updated_at datetime
}

Table repair_line_items {
  id int [pk, increment]
  repair_job_id int [ref: > repair_jobs.id, not null]
  service_catalogue_item_id int [ref: > service_catalogue_items.id, not null]
  quoted_price decimal
  actual_price decimal
  approved_by_customer bool
  notes text
  created_at datetime
  updated_at datetime
}
```

## Lifecycle of a repair

The repair lifecycle is tracked via the `repair_jobs.status` field. The allowed flow is:

- `received` → `awaiting_diagnosis`
- `awaiting_diagnosis` → `quote_ready`
- `quote_ready` → `awaiting_customer_approval`
- `awaiting_customer_approval` → `in_progress`
- `in_progress` → `ready_for_pickup`
- `ready_for_pickup` → `picked_up`

Special cases from the description:

- A simple repair such as a flat tyre may move directly from `received` to `in_progress` if the work is obvious and no quote is necessary.
- If the customer rejects the quote, the bike can be returned to the customer without repair and the job becomes `declined` or `picked_up` once it is collected.

Not allowed transitions:

- `picked_up` cannot return to `in_progress`.
- `ready_for_pickup` cannot go back to `awaiting_customer_approval` once the customer has already accepted the quote.
- A job cannot move from `picked_up` back to `received` because the same repair is a completed record, not a new intake.

## Traceability: entity to story

| Entity | Story it supports |
|---|---|
| `customers` | Story 1, Story 2, Story 8, Story 14 |
| `bikes` | Story 3, Story 5, Story 11 |
| `staff_members` | Story 4, Story 6, Story 7, Story 10 |
| `repair_jobs` | Story 4, Story 7, Story 8, Story 10, Story 14 |
| `price_lists` | Story 9, Story 13 |
| `service_catalogue_items` | Story 7, Story 9, Story 13 |
| `repair_line_items` | Story 7, Story 8, Story 13 |

`bike_photos` (Story 5) and `repair_notes` (Story 6, Story 11) do not have a table
yet — see *Changes since Lab 3* below. Those stories are not fully supported by
the schema until Lab 9 adds them.

## Decision notes required by the brief

### The thing and the copy of the thing

The model separates `bikes` from `repair_jobs` so that each physical bicycle is a unique object with its own serial number, model, and service history. That prevents the April/May confusion described by the owner: two blue Marlins may look the same, but the serial number and the `bike_id` distinguish the real object. A single table with a quantity column would fail to answer which specific bike received a replacement fork, which customer owned it at the time, and which earlier repair record belongs to the second owner after a sale.

### Derived, or stored?

We do not store a `is_overdue` column because it is derived from the repair's promised date and the current date. The business rule is simple: if the repair is not complete and the promised day has passed, then it is overdue. We do store `actual_price` on each repair line item even though it can look derivable from the published list price and a discount. That is deliberate because the business needs to preserve the agreed price for a historical invoice, especially when the annual price list changes and old invoices must not be rewritten.

## Required decisions and assumptions

The model assumes:

- each physical bike has one serial number and one identity regardless of owner changes;
- each repair job belongs to one bike and one customer at the time of intake;
- service prices are versioned by year and remain tied to the historical price list for each invoice.

Those assumptions are documented in [docs/decisions.md](decisions.md).

## Changes since Lab 3

- **Removed `bike_photos`.** Photos are out of scope until Lab 9, per the brief;
  the table is dropped from the schema rather than left empty.
- **Removed `repair_notes`.** This table held the written diagnosis, which is
  also out of scope until Lab 9.
- **Added `updated_at` to every remaining table.** Required this lab; Lab 3
  only listed `created_at`.
- **`customers.full_name` and `customers.phone`: added `NOT NULL`.** The shop
  cannot identify or contact a customer without both.
- **`staff_members.full_name` and `staff_members.role`: added `NOT NULL`.**
- **`bikes.customer_id`, `brand`, `model`, `serial_number`: added `NOT NULL`.**
  A bike without an owner or a serial number cannot be inserted.
- **`bikes.serial_number`: added a unique index.** Serial numbers cannot
  repeat, so two bikes of the same make and model are told apart by this
  column alone.
- **`price_lists.year`: added `NOT NULL` and a unique index.** One published
  list per year.
- **`price_lists.effective_from`: added `NOT NULL`.** `effective_to` stays
  nullable — the current list has no end date yet.
- **`service_catalogue_items.price_list_id`, `name`, `list_price`: added
  `NOT NULL`.**
- **`service_catalogue_items`: added a unique index on `(price_list_id,
  name)`,** not on `name` alone. A service name cannot repeat within one
  year's list, but the same name is expected to reappear in the next year's
  list at a new price — that is the whole point of versioning prices by year.
- **`repair_jobs.bike_id`, `customer_id`, `received_by_staff_id`,
  `received_at`: added `NOT NULL`.** All four are known the moment the bike
  is dropped off.
- **`repair_jobs.status`: added `NOT NULL` with a default of `"received"`,**
  the first state in the lifecycle, so a freshly inserted repair always
  starts there.
- **`repair_jobs.promised_by`, `ready_at`, `picked_up_at` stay nullable.**
  None of the three is known at intake — the promised day is set once the
  job is diagnosed, and the other two are set only once the work reaches
  that stage.
- **`repair_line_items.repair_job_id`, `service_catalogue_item_id`: added
  `NOT NULL`.** `quoted_price`, `actual_price` and `approved_by_customer`
  stay nullable: a simple repair can skip the quote entirely, and the final
  charged price and the customer's answer are not set until later stages.
- **Money columns (`list_price`, `quoted_price`, `actual_price`) are typed
  `decimal(8,2)`.** Lab 3 just said `decimal`; the schema now declares the
  precision and scale, and no column holds money as a `float`.
- **`price_lists.effective_from`/`effective_to` and `repair_jobs.promised_by`
  are `date`; every other time column is `datetime`.** This matches Lab 3's
  intent but is now explicit in the migrations.

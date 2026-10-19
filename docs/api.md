# Wheelhouse API v1

All API routes are under `/api/v1` and return JSON. Prices travel as strings with exactly two decimal places, such as `"45.00"`, so clients do not lose decimal precision.

## Routes

| Verb | Path | Token | Statuses |
| --- | --- | --- | --- |
| GET | `/api/v1/services` | No | 200 |
| GET | `/api/v1/services/:id` | No | 200, 404 |
| POST | `/api/v1/services` | Yes | 201, 400, 401, 422 |
| GET | `/api/v1/repairs` | Yes | 200, 400, 401 |
| GET | `/api/v1/repairs/:id` | Yes | 200, 401, 404 |

Send the token in `Authorization: Bearer <token>`. Filter repairs with `?state=received`; valid states are the keys of the `RepairJob.statuses` enum. A request without an `Origin` header works normally. Browser CORS access is limited to the two origins configured in encrypted credentials, and only the public service GET routes are opened.

To create a service, send JSON with the existing form parameter name and permitted attributes:

```json
{
  "service_catalogue_item": {
    "name": "Tune-up",
    "list_price": "45.00",
    "price_list_id": 1
  }
}
```

## Documents

Service (also the shape used by the collection and a successful create):

```json
{
  "id": 12,
  "name": "Tune-up",
  "price": "45.00",
  "repair_count": 8
}
```

Repair:

```json
{
  "id": 31,
  "state": "picked_up",
  "received_on": "2026-10-12",
  "promised_by": "2026-10-15",
  "picked_up_on": "2026-10-15",
  "bike": {
    "brand": "Trek",
    "model": "FX 2",
    "serial_number": "ABC123"
  },
  "customer": { "name": "Jordan Lee" },
  "lines": [
    {
      "service": "Tune-up",
      "price": "45.00",
      "approved_by_customer": true
    }
  ],
  "total": "45.00",
  "overdue": false
}
```

Repair collection:

```json
[
  {
    "id": 31,
    "state": "picked_up",
    "received_on": "2026-10-12",
    "promised_by": "2026-10-15",
    "picked_up_on": "2026-10-15",
    "bike": { "brand": "Trek", "model": "FX 2", "serial_number": "ABC123" },
    "customer": { "name": "Jordan Lee" },
    "lines": [
      { "service": "Tune-up", "price": "45.00", "approved_by_customer": true }
    ],
    "total": "45.00",
    "overdue": false
  }
]
```

Error:

```json
{ "errors": [ "Record not found" ] }
```

## Document decisions

Prices are decimal strings with two fractional digits in service, repair-line, and total fields. `repair_count` counts distinct repairs with an actual recorded charge for that service. A repair line's `price` is the final `actual_price`; it is `null` when no final charge has been recorded. `total` follows the model's existing total calculation, including a quote where no actual price exists yet.

Repair documents omit foreign keys, phone numbers, staff details, diagnosis, notes, and intake photos. The accounting client needs readable bike, customer, service, and charge information, not internal references or customer contact and workshop-only details. The customer's answer is represented by `approved_by_customer` on each service line because approval is recorded per line.
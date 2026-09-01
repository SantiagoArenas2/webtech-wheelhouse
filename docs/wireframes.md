# Wireframes

## 1. Counter intake screen

Role: Counter staff

![Counter intake](wireframe-counter-intake.svg)

## 2. “Is this bike ready?” lookup screen

Role: Counter staff

![Bike ready lookup](wireframe-bike-ready.svg)

## 3. Mechanic repair detail screen

Role: Mechanic

![Mechanic repair detail](wireframe-mechanic-repair.svg)

## 4. Customer quote approval screen

Role: Customer

![Customer quote approval](wireframe-customer-quote.svg)

## 5. Shop owner dashboard

Role: Shop owner

![Owner dashboard](wireframe-owner-dashboard.svg)

## Navigation graph

```mermaid
flowchart LR
  A[Counter intake] --> B[Ready lookup]
  A --> C[Mechanic repair detail]
  B --> C
  C --> D[Customer quote approval]
  D --> E[Owner dashboard]
  E --> A
  B --> E
  A --> E
  C --> E
  D --> A
```

## Notes

- Every screen is intentionally low fidelity and intentionally plain, as required.
- The counter staff view focuses on intake, status lookup, and “is this bike ready?” decisions.
- The mechanic view focuses on diagnosis, notes, and quote preparation.
- The customer view focuses on the quoted services and the yes/no decision.
- The owner dashboard highlights overdue jobs and promised dates.

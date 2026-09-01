# User stories

## Story set

### 1. As a customer, I want to drop off my bike and leave my contact details, so that the shop can identify the bike and contact me when it is ready.

### 2. As a customer, I want to know what work has been done on my bike before, so that I can understand any past repairs or replacements.

### 3. As a counter staff member, I want to record the bike make, model, and serial number when it arrives, so that the correct bike is returned to the right customer.

### 4. As a counter staff member, I want to see every bike that is currently waiting for diagnosis, so that I can answer the question, “Is my bike ready?” without walking to the workshop.

### 5. As a counter staff member, I want to attach a photo of the bike when it arrives, so that later disputes about scratches or damage are less likely.

### 6. As a mechanic, I want to write a clear diagnosis and repair notes for a bike, so that the next person who looks at the bike can understand the problem and the work done.

### 7. As a mechanic, I want to add a service to a repair and set a quote, so that the customer can approve the repair before work continues.

### 8. As a customer, I want to approve or reject a quote before the mechanic begins work, so that I only pay for work I agree to.

### 9. As a shop owner, I want the shop to display a published price list on the website, so that customers can check routine costs without phoning the shop.

### 10. As a shop owner, I want to track each repair by a promised day, so that I can spot late work before the customer calls.

### 11. As a mechanic, I want to see the work previously done to a bike, so that I can avoid repeating old problems and understand earlier repairs.

### 12. As a website visitor, I want to see the published service list and prices, so that I can decide whether I want to visit the shop.

### 13. As a shop owner, I want to adjust prices in the annual price list without changing prior invoices, so that the business remains accurate and historical records stay stable.

### 14. As a customer, I want to pick up my bike after repair, so that I can take it home once the work is complete.

---

## Large story intentionally split

### Big story (kept as a single item to show scope)

As a mechanic, I want to manage a repair from intake to completion, so that a bike can move from arrival to final pickup without losing information or approvals.

### Split into smaller stories

#### 14a. As a mechanic, I want to diagnose the problem and record notes, so that the rest of the workshop understands the issue.

#### 14b. As a counter staff member, I want to issue a quote and collect approval, so that the customer agrees before the work is done.

#### 14c. As a shop owner, I want to know when a repair is ready or overdue, so that I can manage customer expectations and staffing.

---

## Acceptance criteria

### Story 4: Counter staff can see all bikes awaiting response

1. The screen lists each bike waiting for a decision or completion status.
2. If no bikes are waiting, the screen displays a clear empty-state message instead of a blank area.
3. Each bike row shows the customer name, bike description, and the current repair status.
4. The list can be sorted by the promised day so overdue repairs are visible first.

### Story 7: Mechanic adds a quote and work items

1. The repair screen shows a list of available services and their published prices.
2. The mechanic can add one or more services to the current repair.
3. The system shows the total cost before the customer confirms the work.
4. If the mechanic enters a discount, the screen records the final agreed amount separately from the list price.

### Story 8: Customer approves or rejects a quote

1. The customer sees the quoted services and the total amount before accepting.
2. The screen clearly indicates whether the repair is approved or declined.
3. If a repair is declined, the system keeps the bike on record and shows the customer can collect it unchanged.
4. If a quote is approved, the repair proceeds to the next stage in the workflow.

### Story 10: Shop owner sees overdue or late repairs

1. The owner dashboard highlights bikes whose promised day has passed and the repair is not yet complete.
2. The system separates not-ready bikes from completed and picked-up bikes.
3. The dashboard shows the promised day next to the repair so the owner can compare it to the current date.
4. If there are no overdue bikes, the screen shows a neutral empty state and explains that there are no late repairs.

### Story 6: Mechanic adds diagnosis notes

1. The diagnosis area accepts plain text, lists, or paragraphs, not only short labels.
2. The screen shows which mechanic wrote the note and when it was created.
3. If no notes exist yet, the field displays an empty-state message that invites the mechanic to add one.
4. The notes remain associated with the specific repair, not with the whole shop.

---

## Notes on story quality

These stories are all written as needs from the perspective of a person using the system. They describe value, not tasks. The language is intentionally user-oriented and does not specify implementation details such as database tables, screens, or frameworks.

# Decisions record

The description gives a good starting point, but there are a few things that are not fully decided. I would ask the owner these questions before building the final system.

## 1. Can one bike have more than one owner over time?

**Assumption used to keep working:** A bike belongs to one customer at a time, and the customer recorded with a repair is the person who dropped it off. If ownership changes later, the historical repair record still stays connected to the bike itself.

**What would change if the answer were different:** If ownership were shared or tracked across multiple people, the model would need an `ownership_history` table or a separate `bike_owners` relationship instead of a single `customer_id` on the bike.

## 2. Is every repair job tied to exactly one bike?

**Assumption used to keep working:** Each job is for one bike. A customer can have more than one repair job, but each repair record is still linked to only one bike.

**What would change if the answer were different:** If a single intake could include multiple bikes, we would need a join table or a `dropoff` entity so pricing and notes could be assigned separately to each bike.

## 3. Can the shop discount a job even when the public price list stays the same?

**Assumption used to keep working:** The public list is the standard catalogue, but the shop may still charge less for a repair if it is a regular customer or the work is easier than expected. The final agreed amount is stored on the repair line item, while the published list price is kept for reference.

**What would change if the answer were different:** If discounts were never allowed, the model could be simpler and the final amount would always match the list price. If discounts had formal rules by customer type, we would need a separate policy or customer segment concept.

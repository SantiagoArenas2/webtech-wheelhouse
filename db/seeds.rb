# Wheelhouse seed data
#
# Customers, staff members, bikes, price lists and service catalogue items are
# each keyed on a natural attribute (serial number, year, a name-and-role or
# name-and-phone pair) and loaded with find_or_create_by!, so re-running this
# file does not add duplicates of them.
#
# repair_jobs has no natural key of its own, so that whole section — repairs
# and their line items — is wrapped in a guard that only runs against an empty
# repairs table. Running the file a second time leaves it untouched.
#
# Every write below is a bang method (create!, find_or_create_by!) so a failed
# insert raises instead of silently leaving the database short of rows.
# Dates are computed from Date.current / Time.current, not hard-coded, so the
# "overdue" and "same day" repairs stay true no matter when this file runs.

puts "Seeding staff members..."

counter_staff = StaffMember.find_or_create_by!(full_name: "Nora Higgins", role: "counter")
mechanic_one  = StaffMember.find_or_create_by!(full_name: "Miguel Santos", role: "mechanic")
mechanic_two  = StaffMember.find_or_create_by!(full_name: "Priya Anand", role: "mechanic")
mechanic_three = StaffMember.find_or_create_by!(full_name: "Owen Baxter", role: "mechanic")

puts "Seeding customers..."

customers = {
  daniel: Customer.find_or_create_by!(full_name: "Daniel Ortiz", phone: "+56 9 1234 5678"),
  camila: Customer.find_or_create_by!(full_name: "Camila Fuentes", phone: "+56 9 2345 6789"),
  ethan:  Customer.find_or_create_by!(full_name: "Ethan Walsh", phone: "+44 7700 900123"),
  grace:  Customer.find_or_create_by!(full_name: "Grace Liu", phone: "+1 415 555 0142"),
  marco:  Customer.find_or_create_by!(full_name: "Marco Bellini", phone: "+39 320 123 4567"),
  isabel: Customer.find_or_create_by!(full_name: "Isabel Rojas", phone: "+56 9 3456 7890"),
  tomas:  Customer.find_or_create_by!(full_name: "Tomás Herrera", phone: "+56 9 4567 8901"),
  nina:   Customer.find_or_create_by!(full_name: "Nina Kowalski", phone: "+48 601 234 567"),
  felipe: Customer.find_or_create_by!(full_name: "Felipe Soto", phone: "+56 9 5678 9012"),
  aisha:  Customer.find_or_create_by!(full_name: "Aisha Karim", phone: "+44 7700 900456"),
  lucas:  Customer.find_or_create_by!(full_name: "Lucas Bennett", phone: "+1 415 555 0198"),
  renata: Customer.find_or_create_by!(full_name: "Renata Silva", phone: "+56 9 6789 0123")
}

puts "Seeding bikes..."

def seed_bike(serial_number, customer, brand, model)
  Bike.find_or_create_by!(serial_number: serial_number) do |bike|
    bike.customer_id = customer.id
    bike.brand = brand
    bike.model = model
  end
end

bikes = {
  daniel_marlin:  seed_bike("WH-1001", customers[:daniel], "Trek", "Marlin 5"),
  camila_escape:  seed_bike("WH-1002", customers[:camila], "Giant", "Escape 3"),
  ethan_sirrus:   seed_bike("WH-1003", customers[:ethan], "Specialized", "Sirrus X"),
  grace_quick:    seed_bike("WH-1004", customers[:grace], "Cannondale", "Quick CX"),
  # Same make and model as daniel_marlin above — a different bike, told apart only
  # by its serial number, per requirement 6.
  marco_marlin:   seed_bike("WH-1005", customers[:marco], "Trek", "Marlin 5"),
  isabel_talon:   seed_bike("WH-1006", customers[:isabel], "Giant", "Talon 3"),
  tomas_aspect:   seed_bike("WH-1007", customers[:tomas], "Scott", "Aspect 950"),
  nina_rockhopper: seed_bike("WH-1008", customers[:nina], "Specialized", "Rockhopper"),
  felipe_speeder: seed_bike("WH-1009", customers[:felipe], "Merida", "Speeder 100"),
  aisha_cube:     seed_bike("WH-1010", customers[:aisha], "Cube", "Attention"),
  lucas_bianchi:  seed_bike("WH-1011", customers[:lucas], "Bianchi", "Camaleonte"),
  # Lucas's second bike — the "one customer owns more than one bike" case.
  lucas_fx2:      seed_bike("WH-1012", customers[:lucas], "Trek", "FX 2"),
  renata_escape:  seed_bike("WH-1013", customers[:renata], "Giant", "Escape 3"),
  daniel_kona:    seed_bike("WH-1014", customers[:daniel], "Kona", "Dew")
}

puts "Seeding price lists..."

current_year   = Date.current.year
last_year      = current_year - 1
two_years_ago  = current_year - 2

price_list_current = PriceList.find_or_create_by!(year: current_year) do |list|
  list.effective_from = Date.new(current_year, 1, 1)
  list.effective_to = nil
end

price_list_last_year = PriceList.find_or_create_by!(year: last_year) do |list|
  list.effective_from = Date.new(last_year, 1, 1)
  list.effective_to = Date.new(last_year, 12, 31)
end

price_list_two_years_ago = PriceList.find_or_create_by!(year: two_years_ago) do |list|
  list.effective_from = Date.new(two_years_ago, 1, 1)
  list.effective_to = Date.new(two_years_ago, 12, 31)
end

puts "Seeding the current price list..."

def seed_service(price_list, name, price)
  ServiceCatalogueItem.find_or_create_by!(price_list_id: price_list.id, name: name) do |item|
    item.list_price = price
  end
end

current_services = {
  safety_check:      seed_service(price_list_current, "Safety check", 15),
  brake_adjustment:  seed_service(price_list_current, "Brake adjustment", 20),
  gear_adjustment:   seed_service(price_list_current, "Gear adjustment", 25),
  puncture_repair:   seed_service(price_list_current, "Puncture repair", 18),
  tube_replacement:  seed_service(price_list_current, "Tube replacement", 22),
  chain_replacement: seed_service(price_list_current, "Chain replacement", 30),
  cassette_replacement: seed_service(price_list_current, "Cassette replacement", 45),
  brake_pad_replacement: seed_service(price_list_current, "Brake pad replacement", 28),
  wheel_truing:      seed_service(price_list_current, "Wheel truing", 35),
  bottom_bracket_service: seed_service(price_list_current, "Bottom bracket service", 50),
  full_service:      seed_service(price_list_current, "Full service", 85),
  bike_assembly:     seed_service(price_list_current, "Bike assembly", 70),
  headset_service:   seed_service(price_list_current, "Headset service", 32),
  fork_service:      seed_service(price_list_current, "Fork service", 60),
  disc_brake_bleed:  seed_service(price_list_current, "Disc brake bleed", 40),
  tyre_replacement:  seed_service(price_list_current, "Tyre replacement (per wheel)", 26),
  spoke_replacement: seed_service(price_list_current, "Spoke replacement", 15),
  handlebar_tape_replacement: seed_service(price_list_current, "Handlebar tape replacement", 18),
  saddle_replacement: seed_service(price_list_current, "Saddle replacement", 20),
  pedal_replacement: seed_service(price_list_current, "Pedal replacement", 15),
  derailleur_adjustment: seed_service(price_list_current, "Derailleur adjustment", 24),
  wheel_replacement: seed_service(price_list_current, "Wheel replacement", 95)
}

puts "Seeding historical price lists..."

last_year_services = {
  safety_check:      seed_service(price_list_last_year, "Safety check", 13),
  brake_adjustment:  seed_service(price_list_last_year, "Brake adjustment", 18),
  puncture_repair:   seed_service(price_list_last_year, "Puncture repair", 16),
  chain_replacement: seed_service(price_list_last_year, "Chain replacement", 27),
  full_service:      seed_service(price_list_last_year, "Full service", 78)
}

two_years_ago_services = {
  safety_check:     seed_service(price_list_two_years_ago, "Safety check", 12),
  tube_replacement: seed_service(price_list_two_years_ago, "Tube replacement", 19),
  full_service:     seed_service(price_list_two_years_ago, "Full service", 72)
}

if RepairJob.count.zero?
  puts "Seeding repairs and their line items..."

  def seed_line_item(repair_job, service, quoted:, actual:, approved:, notes: nil)
    RepairLineItem.create!(
      repair_job_id: repair_job.id,
      service_catalogue_item_id: service.id,
      quoted_price: quoted,
      actual_price: actual,
      approved_by_customer: approved,
      notes: notes
    )
  end

  # 1. received — just dropped off, nothing diagnosed or quoted yet.
  repair_daniel_marlin_current = RepairJob.create!(
    bike_id: bikes[:daniel_marlin].id,
    customer_id: customers[:daniel].id,
    received_by_staff_id: counter_staff.id,
    status: "received",
    received_at: 2.days.ago
  )

  # 2. awaiting_diagnosis — a mechanic hasn't looked at it yet.
  RepairJob.create!(
    bike_id: bikes[:camila_escape].id,
    customer_id: customers[:camila].id,
    received_by_staff_id: counter_staff.id,
    status: "awaiting_diagnosis",
    received_at: 3.days.ago
  )

  # 3. quote_ready — diagnosed, services and prices proposed, not yet answered.
  repair_ethan_sirrus = RepairJob.create!(
    bike_id: bikes[:ethan_sirrus].id,
    customer_id: customers[:ethan].id,
    received_by_staff_id: counter_staff.id,
    status: "quote_ready",
    received_at: 4.days.ago,
    promised_by: 3.days.from_now.to_date
  )
  seed_line_item(repair_ethan_sirrus, current_services[:brake_pad_replacement], quoted: 28, actual: nil, approved: nil)
  seed_line_item(repair_ethan_sirrus, current_services[:wheel_truing], quoted: 35, actual: nil, approved: nil)

  # 4. awaiting_customer_approval — quote given, waiting on the customer's answer.
  repair_grace_quick = RepairJob.create!(
    bike_id: bikes[:grace_quick].id,
    customer_id: customers[:grace].id,
    received_by_staff_id: counter_staff.id,
    status: "awaiting_customer_approval",
    received_at: 5.days.ago,
    promised_by: 2.days.from_now.to_date
  )
  seed_line_item(repair_grace_quick, current_services[:full_service], quoted: 85, actual: nil, approved: nil)

  # 5. in_progress — approved and being worked on. This is the discount case:
  # the mechanic agreed to charge below the published list price.
  repair_marco_marlin = RepairJob.create!(
    bike_id: bikes[:marco_marlin].id,
    customer_id: customers[:marco].id,
    received_by_staff_id: counter_staff.id,
    status: "in_progress",
    received_at: 6.days.ago,
    promised_by: 1.day.from_now.to_date
  )
  seed_line_item(repair_marco_marlin, current_services[:chain_replacement], quoted: 30, actual: 25, approved: true,
    notes: "Regular customer — matched last year's price.")
  seed_line_item(repair_marco_marlin, current_services[:gear_adjustment], quoted: 25, actual: 25, approved: true)

  # 6. ready_for_pickup, OVERDUE — promised day has passed and it has not
  # been handed back.
  repair_isabel_talon = RepairJob.create!(
    bike_id: bikes[:isabel_talon].id,
    customer_id: customers[:isabel].id,
    received_by_staff_id: counter_staff.id,
    status: "ready_for_pickup",
    received_at: 8.days.ago,
    promised_by: 3.days.ago.to_date,
    ready_at: 1.day.ago
  )
  seed_line_item(repair_isabel_talon, current_services[:wheel_replacement], quoted: 95, actual: 95, approved: true)

  # 7. picked_up — completed on time.
  repair_tomas_aspect = RepairJob.create!(
    bike_id: bikes[:tomas_aspect].id,
    customer_id: customers[:tomas].id,
    received_by_staff_id: counter_staff.id,
    status: "picked_up",
    received_at: 10.days.ago,
    promised_by: 8.days.ago.to_date,
    ready_at: 8.days.ago,
    picked_up_at: 7.days.ago
  )
  seed_line_item(repair_tomas_aspect, current_services[:full_service], quoted: 85, actual: 85, approved: true)

  # 8. picked_up, SAME DAY — a simple repair that skipped the quote step
  # (received straight to in_progress) and was finished before closing.
  same_day = 5.days.ago
  repair_nina_rockhopper = RepairJob.create!(
    bike_id: bikes[:nina_rockhopper].id,
    customer_id: customers[:nina].id,
    received_by_staff_id: counter_staff.id,
    status: "picked_up",
    received_at: same_day.change(hour: 9),
    promised_by: same_day.to_date,
    ready_at: same_day.change(hour: 15),
    picked_up_at: same_day.change(hour: 17)
  )
  seed_line_item(repair_nina_rockhopper, current_services[:puncture_repair], quoted: nil, actual: 18, approved: nil,
    notes: "Obvious flat, fixed without a formal quote.")

  # 9. declined — the customer heard the price and said no.
  repair_felipe_speeder = RepairJob.create!(
    bike_id: bikes[:felipe_speeder].id,
    customer_id: customers[:felipe].id,
    received_by_staff_id: counter_staff.id,
    status: "declined",
    received_at: 6.days.ago
  )
  seed_line_item(repair_felipe_speeder, current_services[:bottom_bracket_service], quoted: 50, actual: nil, approved: false,
    notes: "Customer will replace the bike instead of repairing it.")

  # 10. in_progress — second example of that state.
  repair_aisha_cube = RepairJob.create!(
    bike_id: bikes[:aisha_cube].id,
    customer_id: customers[:aisha].id,
    received_by_staff_id: counter_staff.id,
    status: "in_progress",
    received_at: 2.days.ago,
    promised_by: 2.days.from_now.to_date
  )
  seed_line_item(repair_aisha_cube, current_services[:disc_brake_bleed], quoted: 40, actual: 40, approved: true)
  seed_line_item(repair_aisha_cube, current_services[:brake_adjustment], quoted: 20, actual: 20, approved: true)
  seed_line_item(repair_aisha_cube, current_services[:handlebar_tape_replacement], quoted: 18, actual: 18, approved: true)

  # 11. ready_for_pickup — not overdue, promised day is still ahead.
  repair_lucas_bianchi = RepairJob.create!(
    bike_id: bikes[:lucas_bianchi].id,
    customer_id: customers[:lucas].id,
    received_by_staff_id: counter_staff.id,
    status: "ready_for_pickup",
    received_at: 4.days.ago,
    promised_by: 1.day.from_now.to_date,
    ready_at: Time.current
  )
  seed_line_item(repair_lucas_bianchi, current_services[:cassette_replacement], quoted: 45, actual: 45, approved: true)

  # 12. awaiting_diagnosis — second bike Lucas owns, second example of the state.
  RepairJob.create!(
    bike_id: bikes[:lucas_fx2].id,
    customer_id: customers[:lucas].id,
    received_by_staff_id: counter_staff.id,
    status: "awaiting_diagnosis",
    received_at: 1.day.ago
  )

  # 13. picked_up — Camila's bike, second repair on record for it.
  repair_camila_escape_earlier = RepairJob.create!(
    bike_id: bikes[:camila_escape].id,
    customer_id: customers[:camila].id,
    received_by_staff_id: counter_staff.id,
    status: "picked_up",
    received_at: 45.days.ago,
    promised_by: 43.days.ago.to_date,
    ready_at: 43.days.ago,
    picked_up_at: 42.days.ago
  )
  seed_line_item(repair_camila_escape_earlier, current_services[:tube_replacement], quoted: 22, actual: 22, approved: true)

  # 14. picked_up — Daniel's Marlin (WH-1001), a second and earlier repair on
  # the SAME bike as repair #1, so that bike has more than one repair on
  # different dates.
  repair_daniel_marlin_earlier = RepairJob.create!(
    bike_id: bikes[:daniel_marlin].id,
    customer_id: customers[:daniel].id,
    received_by_staff_id: counter_staff.id,
    status: "picked_up",
    received_at: 90.days.ago,
    promised_by: 88.days.ago.to_date,
    ready_at: 88.days.ago,
    picked_up_at: 87.days.ago
  )
  seed_line_item(repair_daniel_marlin_earlier, current_services[:brake_adjustment], quoted: 20, actual: 20, approved: true)

  # 15. picked_up, HISTORICAL — from before last January, priced off a since
  # -replaced price list. The charged prices differ from what today's list
  # shows for the same services.
  historical_received = Date.new(two_years_ago, 11, 15).to_time
  repair_daniel_kona_historical = RepairJob.create!(
    bike_id: bikes[:daniel_kona].id,
    customer_id: customers[:daniel].id,
    received_by_staff_id: counter_staff.id,
    status: "picked_up",
    received_at: historical_received,
    promised_by: (historical_received + 2.days).to_date,
    ready_at: historical_received + 2.days,
    picked_up_at: historical_received + 3.days
  )
  seed_line_item(repair_daniel_kona_historical, two_years_ago_services[:safety_check], quoted: 12, actual: 12, approved: true)
  seed_line_item(repair_daniel_kona_historical, two_years_ago_services[:full_service], quoted: 72, actual: 72, approved: true)

  # 16. picked_up — Ethan's Sirrus, an earlier job to give that bike more
  # than one repair too.
  RepairJob.create!(
    bike_id: bikes[:ethan_sirrus].id,
    customer_id: customers[:ethan].id,
    received_by_staff_id: counter_staff.id,
    status: "picked_up",
    received_at: 30.days.ago,
    promised_by: 28.days.ago.to_date,
    ready_at: 28.days.ago,
    picked_up_at: 27.days.ago
  ).tap do |repair|
    seed_line_item(repair, current_services[:puncture_repair], quoted: 18, actual: 18, approved: true)
  end
else
  puts "Repairs already seeded — skipping."
end

puts "Done. #{Customer.count} customers, #{Bike.count} bikes, #{StaffMember.count} staff, " \
     "#{PriceList.count} price lists, #{ServiceCatalogueItem.count} services, " \
     "#{RepairJob.count} repairs, #{RepairLineItem.count} repair line items."

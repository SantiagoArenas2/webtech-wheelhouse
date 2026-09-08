class CreateStaffMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :staff_members do |t|
      t.string :full_name, null: false
      t.string :role, null: false

      t.timestamps
    end
  end
end

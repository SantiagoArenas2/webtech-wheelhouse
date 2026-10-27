class AddRolesAndStaffAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :string, null: false, default: "mechanic"
    add_reference :users, :staff_member, foreign_key: true, index: { unique: true }
    add_index :users, "LOWER(email_address)", unique: true, name: "index_users_on_lower_email_address"
    add_reference :repair_jobs, :received_by_user, foreign_key: { to_table: :users }
  end
end

class AddRoleToUsers < ActiveRecord::Migration[5.1]
  def change
    # role: 0 - customer 1 - moderator 2. superadmin
    add_column :users, :role, :integer, default: 0
  end
end

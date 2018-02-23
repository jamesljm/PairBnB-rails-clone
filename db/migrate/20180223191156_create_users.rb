class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      # user's data
      t.timestamps null: false
      t.string :first_name, null: false
      t.string :last_name
      t.date :birthdate
      t.string :email, null: false, uniqueness: true
      t.integer :gender, default: 0, index: true, null: false
      t.string :phone
      
      # authentications
      t.string :encrypted_password, limit: 128, null: false
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128, null: false
    end

    add_index :users, :email
    add_index :users, :remember_token
  end
end

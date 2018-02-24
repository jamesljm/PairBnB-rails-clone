class CreateListings < ActiveRecord::Migration[5.1]
  def change
    create_table :listings do |t|
      t.string  :name, null: false
      t.integer :place_type
      t.string  :property_type
      t.integer :room_number
      t.integer :bed_number
      t.integer :guest_number
      t.boolean :kitchen, default: false
      t.text    :amenities, array: true, default: []
      t.string  :country
      t.string  :city
      t.string  :state
      t.string  :zipcode
      t.string  :address
      t.integer :price
      t.string  :description
      
      t.timestamps null: false
      
      t.references :user
    end
  end
end
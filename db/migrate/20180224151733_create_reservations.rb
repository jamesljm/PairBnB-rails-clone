class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.date        :start_date, null: false
      t.date        :end_date, null: false
      t.integer     :total_price, nul: false, default: 0
      
      t.references  :user, index: true, foreign_key: true
      t.references  :listing, index: true, foreign_key: true

      t.timestamps  null: false
    end
  end
end

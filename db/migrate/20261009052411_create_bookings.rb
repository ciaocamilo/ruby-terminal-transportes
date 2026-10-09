class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :trip, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :passenger_name, null: false
      t.string :passenger_document, null: false
      t.integer :seat_number, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
    # status 2 = cancelled; a cancelled booking frees its seat
    add_index :bookings, [ :trip_id, :seat_number ], unique: true, where: "status <> 2"
  end
end

class CreateTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :trips do |t|
      t.datetime :departure_at, null: false
      t.decimal :fare, precision: 10, scale: 2, null: false
      t.integer :status, null: false, default: 0
      t.references :vehicle, null: false, foreign_key: true
      t.references :origin, null: false, foreign_key: { to_table: :cities }
      t.references :destination, null: false, foreign_key: { to_table: :cities }

      t.timestamps
    end
    add_index :trips, :departure_at
  end
end

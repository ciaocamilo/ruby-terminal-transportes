class CreateVehicles < ActiveRecord::Migration[8.0]
  def change
    create_table :vehicles do |t|
      t.string :plate, null: false
      t.string :driver, null: false
      t.integer :kind, null: false, default: 0
      t.integer :capacity, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
    add_index :vehicles, :plate, unique: true
  end
end

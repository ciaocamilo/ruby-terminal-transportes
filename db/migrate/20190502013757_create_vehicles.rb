class CreateVehicles < ActiveRecord::Migration[5.1]
  def change
    create_table :vehicles do |t|
      t.string :placa
      t.string :conductor
      t.string :tipo
      t.string :estado

      t.timestamps
    end
  end
end

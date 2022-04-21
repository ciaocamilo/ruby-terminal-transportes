class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips do |t|
      t.string :fecha_hora
      t.integer :valor_pasaje
      t.string :estado
      t.references :vehicle, foreign_key: true
      t.references :origin
      t.references :destiny

      t.timestamps
    end
  end
end

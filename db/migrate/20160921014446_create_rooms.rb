class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.integer :number
      t.string :status
      t.string :building
      t.integer :size

      t.timestamps
    end
  end
end

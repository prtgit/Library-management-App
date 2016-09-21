class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.datetime :booking
      t.string :cancelled_by
      t.boolean :cancelled
      t.string :booked_by
      t.references :room
      t.references :user
      t.timestamps
    end
  end
end

class CreateReservations < ActiveRecord::Migration[5.0]
  def change
    create_table :reservations do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :dish, foreign_key: true
      t.integer :amount

      t.timestamps
    end
  end
end

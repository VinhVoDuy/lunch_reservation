class CreateDeposits < ActiveRecord::Migration[5.0]
  def change
    create_table :deposits do |t|
      t.integer :amount
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end

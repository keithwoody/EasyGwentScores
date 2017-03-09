class CreateRounds < ActiveRecord::Migration[5.0]
  def change
    create_table :rounds do |t|
      t.integer :number, default: 1

      t.timestamps
    end
  end
end

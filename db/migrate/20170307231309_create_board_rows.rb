class CreateBoardRows < ActiveRecord::Migration[5.0]
  def change
    create_table :board_rows do |t|
      t.belongs_to :board_side
      t.string :combat_type
      t.boolean :commanders_horn_active, default: false
      t.boolean :weather_active, default: false
      t.integer :score, default: 0

      t.timestamps
    end
  end
end

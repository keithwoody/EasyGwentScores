class CreateBoardSides < ActiveRecord::Migration[5.0]
  def change
    create_table :board_sides do |t|
      t.integer :score, default: 0

      t.timestamps
    end
  end
end

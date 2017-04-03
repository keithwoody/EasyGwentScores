class AddRoundIdToBoardSides < ActiveRecord::Migration[5.0]
  def change
    add_reference :board_sides, :round, foreign_key: true
  end
end

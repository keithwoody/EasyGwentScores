class CreateCardPlays < ActiveRecord::Migration[5.0]
  def change
    create_table :card_plays, id: false do |t|
      # played by
      t.belongs_to :board_side, foreign_key: true
      # played to
      t.belongs_to :board_row, foreign_key: true
      # card played
      t.belongs_to :card, foreign_key: true

      t.timestamps
    end
  end
end

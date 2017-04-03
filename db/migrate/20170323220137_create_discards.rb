class CreateDiscards < ActiveRecord::Migration[5.0]
  def change
    create_table :discards do |t|
      t.belongs_to :board_side, foreign_key: true
      t.belongs_to :card, foreign_key: true

      t.timestamps
    end
  end
end

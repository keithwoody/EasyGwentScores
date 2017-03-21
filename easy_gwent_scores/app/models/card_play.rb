class CardPlay < ApplicationRecord
  belongs_to :board_side, inverse_of: :card_plays
  belongs_to :board_row, required: false
  belongs_to :card


  after_create do
    if board_row
      board_row.recalculate_score(self)
    end
  end

  end
end

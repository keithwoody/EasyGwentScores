class CardPlay < ApplicationRecord
  belongs_to :board_side, inverse_of: :card_plays
  belongs_to :board_row, required: false
  belongs_to :card

  before_validation :set_board_side, on: :create

  after_create do
    if board_row
      board_row.recalculate_score(self)
    end
  end

  def set_board_side
    if board_side.nil?
      self.board_side = board_row.board_side if board_row
    end
  end
end

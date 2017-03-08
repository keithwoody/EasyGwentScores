class CardPlay < ApplicationRecord
  belongs_to :board_side
  belongs_to :board_row, required: false
  belongs_to :card

  before_validation :set_board_side, on: :create

  def set_board_side
    if board_side.nil?
      self.board_side = board_row.board_side if board_row
    end
  end
end

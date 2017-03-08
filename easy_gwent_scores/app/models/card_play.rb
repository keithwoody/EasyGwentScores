class CardPlay < ApplicationRecord
  belongs_to :board_side
  belongs_to :board_row
  belongs_to :card

  before_validation :set_board_side, on: :create

  def set_board_side
    self.board_side = board_row.board_side unless board_side
  end
end

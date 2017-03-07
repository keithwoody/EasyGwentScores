class CardPlay < ApplicationRecord
  belongs_to :board_side
  belongs_to :board_row
  belongs_to :card
end

class Discard < ApplicationRecord
  belongs_to :board_side, inverse_of: :discards
  belongs_to :card, inverse_of: :discards
end

class Discard < ApplicationRecord
  belongs_to :board_side, inverse_of: :discards
  belongs_to :card

  scope :combat, -> { includes(:card).where(cards: {card_type: %w[Unit Hero]}) }
end

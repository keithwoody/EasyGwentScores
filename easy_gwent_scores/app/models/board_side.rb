class BoardSide < ApplicationRecord
  has_and_belongs_to_many :hand_cards, class: 'Card'
  has_and_belongs_to_many :game_deck_cards, class: 'Card'
  has_and_belongs_to_many :discarded_cards, class: 'Card'

  has_one :melee_row, class: 'BoardRow'
  has_one :ranged_row, class: 'BoardRow'
  has_one :siege_row, class: 'BoardRow'

end

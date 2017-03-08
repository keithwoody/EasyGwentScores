class BoardSide < ApplicationRecord
  has_and_belongs_to_many :hand_cards, class_name: 'Card'
  has_and_belongs_to_many :game_deck_cards, class_name: 'Card'
  has_and_belongs_to_many :discarded_cards, class_name: 'Card'

  has_many :board_rows

  after_create do
    board_rows.melee.create!
    board_rows.ranged.create!
    board_rows.siege.create!
  end

  def melee_row
    board_rows.melee.first
  end

  def ranged_row
    board_rows.melee.first
  end

  def siege_row
    board_rows.melee.first
  end

end

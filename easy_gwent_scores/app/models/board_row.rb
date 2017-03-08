class BoardRow < ApplicationRecord
  belongs_to :board_side
  has_and_belongs_to_many :played_cards, :join_table => "card_plays"

  validates :combat_type,
    presence: true,
    uniqueness: {scope: :board_side_id},
    inclusion: {in: %w[Melee Ranged Siege]}

  scope :melee, ->{ where(combat_type: 'Melee') }
  scope :ranged, ->{ where(combat_type: 'Ranged') }
  scope :siege, ->{ where(combat_type: 'Siege') }

end

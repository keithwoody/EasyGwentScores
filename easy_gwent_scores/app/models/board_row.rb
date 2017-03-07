class BoardRow < ApplicationRecord
  belongs_to :board_side
  has_and_belongs_to_many :played_cards, :join_table => "board_rows_cards"

  validates :combat_type,
    presence: true,
    uniqueness: true,
    inclusion: {in: %w[Melee Ranged Siege]}
end

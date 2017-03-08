class BoardRow < ApplicationRecord
  belongs_to :board_side
  has_many :card_plays, after_add: :recalculate_score
  has_many :cards, through: :card_plays

  validates :combat_type,
    presence: true,
    uniqueness: {scope: :board_side_id},
    inclusion: {in: %w[Melee Ranged Siege]}

  scope :melee, ->{ where(combat_type: 'Melee') }
  scope :ranged, ->{ where(combat_type: 'Ranged') }
  scope :siege, ->{ where(combat_type: 'Siege') }

  def recalculate_score(obj)
    new_total = cards(true).sum(:strength)
    update(score: new_total)
  end

end

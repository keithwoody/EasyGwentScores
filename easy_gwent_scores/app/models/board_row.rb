class BoardRow < ApplicationRecord
  belongs_to :board_side, inverse_of: :board_rows
  has_many :card_plays, dependent: :nullify, inverse_of: :board_row
  has_many :cards, through: :card_plays

  validates :combat_type,
    presence: true,
    uniqueness: {scope: :board_side_id},
    inclusion: {in: %w[Melee Ranged Siege]}

  scope :melee, ->{ where(combat_type: 'Melee') }
  scope :ranged, ->{ where(combat_type: 'Ranged') }
  scope :siege, ->{ where(combat_type: 'Siege') }

  after_update do
    if score_changed?
      board_side.update_score
    end
  end

  def recalculate_score(card_play)
    if card_play.card.commanders_horn?
      self.commanders_horn_active = true
    end
    self.score = row_scores.sum
    save!
  end

  def row_scores
    cards.reload.map{ |c| c.row_score(self) }
  end

  def explain_row_scores
    cards.reload.map{ |c| [c.name, c.card_type, c.strength, c.row_score(self)] }
  end

end

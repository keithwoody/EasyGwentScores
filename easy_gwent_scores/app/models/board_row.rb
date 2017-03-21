class BoardRow < ApplicationRecord
  belongs_to :board_side, inverse_of: :board_rows
  has_many :card_plays, dependent: :nullify, inverse_of: :board_row
  has_many :cards, through: :card_plays

  COMBAT_TYPES = %w[Melee Ranged Siege].freeze
  validates :combat_type,
    presence: true,
    uniqueness: {scope: :board_side_id},
    inclusion: {in: COMBAT_TYPES}

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
    self.score = card_scores.sum
    save!
  end

  def card_scores
    cards.reload.map{ |c| c.row_score(self) }
  end

  def explain_card_scores
    cards.reload.map{ |c| [c.name, c.card_type, c.strength, c.row_score(self)] }
  end

  def morale_boosts_for( card )
    cards.morale.where('id != ?', card.id).count
  end

  def tight_bonds_for( card )
    return 0 unless card.tight_bond?
    cards.tight_bond.bound_to( card ).count
  end
end

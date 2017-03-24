class BoardRow < ApplicationRecord
  belongs_to :board_side, inverse_of: :board_rows
  has_many :card_plays, dependent: :nullify, inverse_of: :board_row
  has_many :cards, -> (row){ where.not(id: Discard.where(board_side: row.board_side).pluck(:card_id)) }, through: :card_plays

  COMBAT_TYPES = %w[Melee Ranged Siege].freeze
  validates :combat_type,
    inclusion: {in: COMBAT_TYPES, message: "must be one of #{COMBAT_TYPES.to_sentence(last_word_connector: ' or ')}"},
    uniqueness: {scope: :board_side_id}

  scope :melee, ->{ where(combat_type: 'Melee') }
  scope :ranged, ->{ where(combat_type: 'Ranged') }
  scope :siege, ->{ where(combat_type: 'Siege') }

  before_save do
    if weather_active_changed? || commanders_horn_active_changed?
      self.score = calculate_score
    end
  end

  after_update do
    if score_changed?
      board_side.update_score
    end
  end

  def calculate_score
    cards.reload.inject(0){|sum, c| sum += c.strength_in_row(self) }
  end

  def morale_boosts_for( card )
    cards.morale.where('id != ?', card.id).count
  end

  def tight_bonds_for( card )
    return 0 unless card.tight_bond?
    cards.tight_bond.bound_to( card ).count
  end
end

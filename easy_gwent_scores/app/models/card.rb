class Card < ApplicationRecord
  belongs_to :faction, inverse_of: :cards
  has_many :card_plays, dependent: :delete_all, inverse_of: :card
  validates :name,
    presence: true,
    uniqueness: true

  # type scopes
  scope :leader, -> { where(card_type: 'Leader') }
  scope :hero, -> { where(card_type: 'Hero') }
  scope :special, -> { where(card_type: 'Special') }
  scope :weather, -> { where(card_type: 'Weather') }
  scope :unit, -> { where(card_type: 'Unit') }
  scope :non_leader, -> { where('card_type != ?', 'Leader') }
  # row scopes
  scope :global, -> { where(combat_row: 'n/a') }
  scope :melee, -> { where('combat_row LIKE ?', '%Close%') }
  scope :ranged, -> { where('combat_row LIKE ?', '%Ranged%') }
  scope :siege, -> { where('combat_row LIKE ?', '%Siege%') }
  # ability
  scope :morale, -> { where(special_ability: 'Morale boost') }
  scope :tight_bond, -> { where(special_ability: 'Tight Bond') }
  scope :bound_to, -> (c) { where('id != ?', c.id).where('name like ?', c.name.remove(/ \d\/\d/)+'%') }
  scope :spy, -> {where(special_ability: 'Spy')}

  # combat_row predicates
  def melee?
    combat_row.eql?('Close combat')
  end

  def ranged?
    combat_row.eql?('Ranged combat')
  end

  def siege?
    combat_row.eql?('Siege')
  end

  def whole_board?
    weather? || (name =~ /^Scorch/) ? true : false
  end

  # card_type predicates
  def hero?
    card_type.eql?('Hero')
  end

  def unit?
    card_type.eql?('Unit')
  end

  def weather?
    card_type.eql?('Weather')
  end

  def special?
    card_type.eql?('Special')
  end

  # ability predicates
  def commanders_horn?
    if name+special_ability =~ /Horn/
      true
    else
      false
    end
  end

  def spy?
    special_ability.eql?('Spy')
  end

  def tight_bond?
    special_ability.eql?('Tight Bond')
  end

  # card play helpers
  def row_score(row)
    val = strength
    if unit?
      # Weather on? => reduce unit strength to 1
      val = 1 if row.weather_active? && val > 1

      # Special ability:
      #   Morale => +1 to all units in row (except self)
      val += row.morale_boosts_for( self )

      # Special ability:
      #   Tight Bond => x2 related cards
      bond_count = row.tight_bonds_for( self )
      val *= bond_count * 2 if bond_count > 0

      # todo: Apply scoring rule
      # Special ability:
      #   Berserker => x2 on transform, +1 to related units (Young Berserker)

      # Commanders horn? => x2 all units in row
      val *= 2 if row.commanders_horn_active?
    end

    val
  end
end

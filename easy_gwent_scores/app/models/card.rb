class Card < ApplicationRecord
  belongs_to :faction

  # type scopes
  scope :leader, -> { where(card_type: 'Leader') }
  scope :hero, -> { where(card_type: 'Hero') }
  scope :special, -> { where(card_type: 'Special') }
  scope :weather, -> { where(card_type: 'Weather') }
  scope :unit, -> { where(card_type: 'Unit') }
  # row scopes
  scope :global, -> { where(combat_row: 'n/a') }
  scope :melee, -> { where('combat_row LIKE ?', '%Close%') }
  scope :ranged, -> { where('combat_row LIKE ?', '%Ranged%') }
  scope :siege, -> { where('combat_row LIKE ?', '%Siege%') }

  def commanders_horn?
    if name+special_ability =~ /Horn/
      true
    else
      false
    end
  end

  def hero?
    card_type.eql?('Hero')
  end

  def weather?
    card_type.eql?('Weather')
  end

  def row_score(row)
    val = strength
    unless hero?
      #  Weather on? => reduce all units to 1
      if row.weather_active?
        val = 1 if val > 1
      end
      # todo: Apply scoring rules
      #  Special ability:
      #    Morale => +1 to all units in row (except self)
      #    Tight Bond => x2 related cards
      #    Berserker => x2 on transform, +1 to related units (Young Berserker)
      # Commanders horn? => x2 all units in row
      if row.commanders_horn_active?
        val *= 2
      end
    end
    val
  end
end

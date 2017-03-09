class Card < ApplicationRecord
  belongs_to :faction

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

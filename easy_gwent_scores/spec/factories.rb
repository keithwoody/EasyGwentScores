FactoryGirl.define do
  factory :discard do
    board_side nil
    card nil
  end
  factory :card_play do
    board_side
  end
  factory :card do
    faction
    sequence(:name) {|n| "Card #{n}" }
    special_ability 'None'
    factory :hero do
      card_type 'Hero'
    end
    factory :unit do
      card_type 'Unit'
      factory :melee_unit do
        combat_row 'Close combat'
      end
      factory :morale do
        special_ability 'Morale boost'
      end
      factory :tight_bond do
        special_ability 'Tight Bond'
      end
    end
    factory :weather do
      card_type 'Weather'
      factory :frost do
        name "Biting Frost"
      end
      factory :fog do
        name "Impenetrable Fog"
      end
      factory :rain do
        name "Torrential Rain"
      end
      factory :storm do
        name "Skellige Storm"
      end
      factory :clear_weather do
        name "Clear Weather"
      end
    end
    factory :special do
      card_type 'Special'
      factory :commanders_horn do
        sequence(:name) {|n| "Commander's Horn #{n}" }
        special_ability "Horn on any row"
      end
      factory :scorch do
        sequence(:name) {|n| "Scorch #{n}" }
        special_ability "Scorch"
      end
    end
  end
  factory :faction do
    sequence(:name) {|n| "Faction #{n}" }
  end
  factory :round do
  end
  factory :board_side do
    round
  end
  factory :board_row do
    board_side
    combat_type 'Melee'
  end
end

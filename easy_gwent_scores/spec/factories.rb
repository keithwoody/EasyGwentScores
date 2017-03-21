FactoryGirl.define do
  factory :card_play do
    board_side
  end
  factory :card do
    faction
    sequence(:name) {|n| "Card #{n}" }
    factory :hero do
      card_type 'Hero'
    end
    factory :unit do
      card_type 'Unit'
      factory :morale do
        special_ability 'Morale boost'
      end
      factory :tight_bond do
        special_ability 'Tight Bond'
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

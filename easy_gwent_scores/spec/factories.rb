FactoryGirl.define do
  factory :card do
    faction
    sequence(:name) {|n| "Card #{n}" }
    factory :hero do
      card_type 'Hero'
    end
    factory :unit do
      card_type 'Unit'
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

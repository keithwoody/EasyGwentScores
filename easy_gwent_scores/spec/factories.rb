FactoryGirl.define do
  factory :card do
    faction
    sequence(:name) {|n| "Card #{n}" }
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

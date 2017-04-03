namespace :cards do
  desc "Consolidate card_types"
  task cleanup_import_values: :environment do
    if Card.where('card_type like ?', 'Weather_card').or(Card.where('card_type like ?', 'Special_card')).exists?
      Card.where('card_type like ?', 'Weather_card').update(card_type: 'Weather')
      Card.where('card_type like ?', 'Special_card').update(card_type: 'Special')
      puts "Fixed card_types"
      puts Card.order(:card_type).group(:card_type).count
    end
    if Card.where('combat_row like ?', 'Close combat% __% Ranged%').exists?
      Card.where('combat_row like ?', 'Close% __% Ranged%').update(combat_row: 'Close or Ranged')
      puts "Fixed combat_rows"
      puts Card.order(:combat_row).group(:combat_row).count
    end
    if Card.where(special_ability: 'n/a').exists?
      Card.unit.where(special_ability: 'n/a').update(special_ability: 'None')
      Card.where('name like ?', 'Decoy%').where(special_ability: 'n/a').update(special_ability: 'Swap with played card')
      Card.where('name like ?', 'Biting%').where(special_ability: 'n/a').update(special_ability: 'Frost affects melee rows')
      Card.where('name like ?', 'Impenetrable%').where(special_ability: 'n/a').update(special_ability: 'Fog affects ranged rows')
      Card.where('name like ?', 'Torrential%').where(special_ability: 'n/a').update(special_ability: 'Rain affects siege rows')
      puts "Fixed special_abilities"
      puts Card.non_leader.order(:special_ability).group(:special_ability).count
    end
    if Card.special.where('name like ?', 's Horn%').exists?
      Card.where('name like ?', 's Horn%').each {|r| r.update(name: r.name.sub('s', "Commander's"))}
      puts "Fixed commander's horn names"
      puts Card.where('name like ?', '%Horn%').pluck(:name)
    end
  end
end

require 'open-uri'
namespace :import do
  desc "Retrieve factions from wiki"
  task factions: :environment do
    Faction.create(name: 'Neutral',
                   description: 'Cards that are available to use in any deck',
                   wiki_path: '/wiki/Neutral_Gwent_cards')

    doc = Nokogiri::HTML(open(WIKI_BASE+'/wiki/Gwent'))
    doc.css('div#mw-content-text ul:first-of-type li').map do |e|
      name = e.css('b').text
      Faction.create( name: name,
                      description: e.text.strip,
                      wiki_path: e.css('a').attr('href').value )
    end
  end

end

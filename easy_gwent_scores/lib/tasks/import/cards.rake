require 'open-uri'
namespace :import do
  desc "Retrieve faction cards from wiki"
  task cards: :environment do
    puts "#{Faction.count} factions"
    Faction.all.each do |faction|
      puts "#{faction.name}"
      if faction.cards.empty?
        puts " Importing cards..."
        columns = Card.content_columns.map(&:name).slice(0,8)
        doc = Nokogiri::HTML(open( WIKI_BASE+faction.wiki_path ))
        doc.css('div#mw-content-text table tr')[1..-1].map do |row|
          values = row.css('td')[1..7].map do |td|
                    val = if td.css('a.image').any?
                             td.css('a.image').attr('title').value
                           else
                             # sub to get rid of 0 from hidden div
                             td.text.strip.sub(/^0n/, "n").sub(/0N/, 'N')
                           end
                 end
          # change extracted name to name and num_related count
          if values[0] =~ /([\w\s]+) \((\d)\)/
            values[0] = [$1,$2.to_i]
          else
            values[0] = [values[0], 1]
          end
          card = Hash[columns.zip(values.flatten)]
          if card['num_related'] > 1
            name = card['name']
            1.upto(card['num_related']) do |n|
              card['name'] = name + " #{n}/#{card['num_related']}"
              faction.cards.create( card )
            end
          else
            faction.cards.create( card )
          end
        end
        puts " ...total cards #{faction.cards.count}"
      else
        puts " ...already imported"
      end
    end
  end

end

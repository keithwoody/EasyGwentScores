require 'nokogiri'
require 'open-uri'
require 'pp'

wiki_base = 'http://witcher.wikia.com'
doc = Nokogiri::HTML(open(wiki_base+'/wiki/Gwent'))
factions = doc.css('div#mw-content-text ul:first-of-type li').map do |e|
  name = e.css('b').text
  {name: name,
   description: e.text.sub(name, '').sub(/^.{3}/, '').strip,
   path: e.css('a').attr('href').value}
end
factions << {name: 'Neutral Cards',
             description: 'Available to use in any deck',
             path: '/wiki/Neutral_Gwent_cards'}
# pp factions

cards = {}
factions.each do |f|
  doc2 = Nokogiri::HTML(open(wiki_base+f[:path]))
  #slice to skip icon, sub to fix Specialability
  fields = doc2.css('div#mw-content-text table th').map{ |e| e.text.strip.sub('lab', 'l ab')}[1..7]
  cards[f[:name]] = []
  doc2.css('div#mw-content-text table tr')[1..-1].map do |row|
    values = row.css('td')[1..7].map do |td|
              val = if td.css('a.image').any?
                       td.css('a.image').attr('title').value
                     else
                       # sub to get rid of 0 from hidden element
                       td.text.strip.sub(/^0n/, "n").sub(/0N/, 'N')
                     end
           end
    cards[f[:name]] << Hash[ fields.zip( values ) ]
  end
end
pp cards

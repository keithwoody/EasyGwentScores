require 'open-uri'
class Faction < ApplicationRecord
  WIKI_BASE = 'http://witcher.wikia.com'
  validates :name,
    presence: true,
    uniqueness: true

  has_many :cards, inverse_of: :faction do
    def import_from_wiki
      faction = proxy_association.owner
      columns = Card.content_columns.map(&:name).slice(0,8)
      doc = Nokogiri::HTML(open(WIKI_BASE+faction.wiki_path))
      doc.css('div#mw-content-text table tr')[1..-1].map do |row|
        values = row.css('td')[1..7].map do |td|
                  val = if td.css('a.image').any?
                           td.css('a.image').attr('title').value
                         else
                           # sub to get rid of 0 from hidden div
                           td.text.strip.sub(/^0n/, "n").sub(/0N/, 'N')
                         end
               end
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
            self.create( card ) unless self.where(name: card['name']).exists?
          end
        else
          self.create( card ) unless self.where(name: card['name']).exists?
        end
      end
      count
    end
  end

  def self.import_from_wiki
    doc = Nokogiri::HTML(open(WIKI_BASE+'/wiki/Gwent'))
    doc.css('div#mw-content-text ul:first-of-type li').map do |e|
      name = e.css('b').text
      unless where(name: name).exists?
        create!( name: name,
                 description: e.text.sub(name, '').sub(/^.{3}/, '').strip,
                 wiki_path: e.css('a').attr('href').value )
      end
    end
  end
end

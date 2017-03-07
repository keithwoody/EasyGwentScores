require 'open-uri'
class Faction < ApplicationRecord
  WIKI_BASE = 'http://witcher.wikia.com'

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

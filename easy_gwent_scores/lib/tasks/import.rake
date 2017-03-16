WIKI_BASE = 'http://witcher.wikia.com'
desc "Imports factions and cards"
task import: ['import:factions', 'import:cards']

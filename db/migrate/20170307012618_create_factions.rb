class CreateFactions < ActiveRecord::Migration[5.0]
  def change
    create_table :factions do |t|
      t.string :name
      t.string :description
      t.string :wiki_path

      t.timestamps
    end
  end
end

class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.belongs_to :faction, foreign_key: true
      t.string :name
      t.integer :num_related
      t.string :card_type
      t.string :combat_row
      t.integer :strength
      t.string :special_ability
      t.string :description
      t.string :source

      t.timestamps
    end
  end
end

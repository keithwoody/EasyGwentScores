class BoardSide < ApplicationRecord
  belongs_to :round

  has_many :board_rows, dependent: :destroy
  after_create do
    board_rows.melee.create!
    board_rows.ranged.create!
    board_rows.siege.create!
  end

  has_many :global_card_plays, ->{ where(board_row_id: nil) },
    class_name: 'CardPlay',
    after_add: :apply_weather,
    dependent: :delete_all

  def apply_weather(card_play)
    if card_play.card.weather?
      round.side_one.apply_row_weather( card_play.card )
      round.side_two.apply_row_weather( card_play.card )
    end
  end

  def apply_row_weather( card )
    name = card.name
    if name =~ /Frost/
      melee_row.update(weather_active: true)
    elsif name =~ /Fog/
      ranged_row.update(weather_active: true)
    elsif name =~ /Rain/
      siege_row.update(weather_active: true)
    elsif name =~ /Storm/
      ranged_row.update(weather_active: true)
      siege_row.update(weather_active: true)
    elsif name =~ /Clear/
      board_rows.update(weather_active: false)
    end
  end

  def melee_row
    board_rows.melee.first
  end

  def ranged_row
    board_rows.ranged.first
  end

  def siege_row
    board_rows.siege.first
  end

  def update_score
    update(score: board_rows.sum(:score))
  end
end

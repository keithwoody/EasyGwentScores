class BoardSide < ApplicationRecord
  belongs_to :round, inverse_of: :board_sides

  has_many :board_rows, dependent: :destroy
  has_one :melee_row, ->{ melee }, class_name: 'BoardRow', inverse_of: :board_side
  has_one :ranged_row, ->{ ranged }, class_name: 'BoardRow', inverse_of: :board_side
  has_one :siege_row, ->{ siege }, class_name: 'BoardRow', inverse_of: :board_side
  after_create do
    create_melee_row!
    create_ranged_row!
    create_siege_row!
  end

  has_many :card_plays
  has_many :global_card_plays, ->{ where(board_row_id: nil) },
    class_name: 'CardPlay',
    dependent: :delete_all

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

  def other_side
    round.board_sides.where('id != ?', self.id).first
  end

  def row_for( card )
    side = card.spy? ? other_side : self
    if card.melee?
      side.melee_row
    elsif card.ranged?
      side.ranged_row
    elsif card.siege?
      side.siege_row
    end
  end

  def play( card, row: nil, replace: nil )
    if card.special?
      if card.whole_board?
        # affects both sides: clear weather, scorch
        global_card_plays.create(card: card)
      else
        if card.commanders_horn?
          # specify row: horn
          raise "Choose a row to apply #{card.name}" unless row
          card_plays.create(card: card, board_row: row)
        else
          # specify card: decoy
          raise "Choose a card to replace with #{card.name}" unless replace
          card_plays.where(card: replace, board_row_id: board_row_ids).update(card: card)
          #game.hand << replace
        end
      end
    elsif card.weather?
      global_card_plays.create(card: card)
    elsif card.leader?
      card_plays.create(card: card)
    else
      # Unit/Hero
      # auto-select row unless one was passed in
      raise "Choose a row to play #{card.name}" if card.agile? && row.nil?
      row ||= row_for( card )
      card_plays.create(card: card, board_row: row)
    end

  end

  def update_score
    update(score: board_rows.sum(:score))
  end
end

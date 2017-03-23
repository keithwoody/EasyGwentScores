class CardPlay < ApplicationRecord
  belongs_to :board_side, inverse_of: :card_plays
  has_one :round, through: :board_side
  delegate :other_side, to: :board_side
  belongs_to :board_row, required: false
  belongs_to :card

  validates :board_row_id, presence: true, if: :card_requires_combat_row?

  # when a Card is played by a BoardSide it can:
  #   * affect the score of:
  #     - the row it's played in (Unit, Hero, Decoy, Horn)
  #     - other cards in it's row (Morale, Tight Bond)
  #     - the whole board (Weather, Scorch)
  after_create do
    if board_row
      if card.commanders_horn?
        board_row.commanders_horn_active = true
      end
      board_row.update(score: board_row.calculate_score)
    elsif card.whole_board?
      # update side scores
      apply_global_effects
    end
  end

  protected

  def apply_global_effects
    if card.weather?
      board_side.apply_row_weather( card )
      other_side.apply_row_weather( card )
    elsif card.scorch?
      scorch_level = round.unit_cards.maximum(:strength)
      round.board_sides.each do |side|
        side.unit_cards.where(strength: scorch_level).pluck(:id).each do |cid|
          side.discards.create(card_id: cid)
        end
      end
      board_side.discards.create(card: card)
    end
  end

  def card_requires_combat_row?
    card && !card.whole_board?
  end

end

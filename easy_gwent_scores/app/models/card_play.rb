class CardPlay < ApplicationRecord
  belongs_to :board_side, inverse_of: :card_plays
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
      raise "TODO: discard from each side card(s) with highest row_score"
    end
  end

  def card_requires_combat_row?
    card && !card.whole_board?
  end

end

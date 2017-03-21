class CardPlay < ApplicationRecord
  belongs_to :board_side, inverse_of: :card_plays
  belongs_to :board_row, required: false
  belongs_to :card

  validates :board_row_id, presence: true, if: :card_requires_combat_row?

  after_create do
    if board_row
      board_row.recalculate_score(self)
    end
  end

  protected

  def card_requires_combat_row?
    card && !card.whole_board?
  end

end

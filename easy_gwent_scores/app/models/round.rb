class Round < ApplicationRecord
  has_many :board_sides, -> { includes(:board_rows).order(:created_at) }, dependent: :destroy, inverse_of: :round
  has_many :unit_cards, through: :board_sides

  after_create do
    2.times do
      board_sides.create!
    end
  end

  def side_one
    board_sides.first
  end

  def side_two
    board_sides.second
  end
end

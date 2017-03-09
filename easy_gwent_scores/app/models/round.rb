class Round < ApplicationRecord
  has_many :board_sides, dependent: :destroy

  after_create do
    board_sides.create! #one
    board_sides.create! #two
  end

  def side_one
    board_sides.order(:created_at).first
  end

  def side_two
    board_sides.order(:created_at).last
  end
end

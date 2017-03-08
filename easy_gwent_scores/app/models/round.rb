class Round < ApplicationRecord
  has_many :board_sides

  after_create do
    board_sides.create!
    board_sides.create!
  end

  def side_one
    board_sides.order(:created_at).first
  end

  def side_two
    board_sides.order(:created_at).last
  end
end

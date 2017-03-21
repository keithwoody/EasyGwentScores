require 'rails_helper'

RSpec.describe BoardRow, type: :model do
  it { is_expected.to belong_to(:board_side) }
  it { is_expected.to have_many(:card_plays) }
  it { is_expected.to have_many(:cards).through(:card_plays) }
  it { is_expected.to validate_presence_of(:combat_type) }
  it { is_expected.to validate_uniqueness_of(:combat_type).scoped_to(:board_side_id) }
  it { is_expected.to validate_inclusion_of(:combat_type).in_array(BoardRow::COMBAT_TYPES) }

  describe "Callbacks" do
    describe "after_update" do
      it "updates the score for the associated BoardSide when the row score changes"
    end
  end

  describe "#morale_boosts_for( card )" do
    it "returns a count of morale cards in the row for non-morale cards"
    it "returns a decremented count of morale cards in the row for morale cards"
  end

  describe "#tight_bonds_for( card )" do
    it "returns 0 for cards that don't have the Tight Bond ability"
    it "returns a count of related Tight Bond cards in the row"
  end
end

require 'rails_helper'

RSpec.describe BoardRow, type: :model do
  it { is_expected.to belong_to(:board_side) }
  it { is_expected.to have_many(:card_plays) }
  it { is_expected.to have_many(:cards).through(:card_plays) }
  it { is_expected.to validate_inclusion_of(:combat_type).in_array(BoardRow::COMBAT_TYPES) }
  it { is_expected.to validate_uniqueness_of(:combat_type).scoped_to(:board_side_id) }

  let(:side_one) { create(:board_side) }
  describe "Callbacks" do
    subject { side_one.melee_row }
    describe "before_save" do
      it "recalculates the score when the weather status changes" do
        allow(subject).to receive(:calculate_score).and_return(5)
        expect{ subject.update(weather_active: true) }.to change{ subject.score }.from(0).to(5)
      end
    end
    describe "after_update" do
      it "updates the score for the associated BoardSide when the row score changes" do
        expect( subject.score ).to eq 0
        expect{ subject.update(score: 5 ) }.to change{ side_one.reload.score }.from(0).to(5)
      end
    end
  end

  describe "#calculate_score" do
    before do
      side_one.ranged_row.card_plays.delete_all
      side_one.card_plays.create(board_row: side_one.siege_row, card: create(:unit, strength: 6))
      side_one.card_plays.create(board_row: side_one.siege_row, card: create(:hero, strength: 7))
    end
    let(:empty_row) { side_one.ranged_row }
    it "returns 0 for a row with no cards" do
      expect( empty_row.cards ).to be_empty
      expect( empty_row.calculate_score ).to eq 0
    end
    let(:multi_card_row) { side_one.siege_row }
    it "returns the sum of row_scores for cards played in the row" do
      expect( multi_card_row.cards.count ).to eq 2
      expect( multi_card_row.calculate_score ).to eq 13
    end
  end

  let(:regular_unit) { create(:unit) }
  describe "#morale_boosts_for( card )" do
    let(:morale1) { create(:morale) }
    let(:morale2) { create(:morale) }
    subject { side_one.melee_row }
    before do
      side_one.card_plays.create(board_row: subject, card: regular_unit )
      side_one.card_plays.create(board_row: subject, card: morale1 )
      side_one.card_plays.create(board_row: subject, card: morale2 )
    end
    it "returns a count of morale cards in the row for non-morale units" do
      expect( subject.morale_boosts_for( regular_unit ) ).to eq 2
    end
    it "returns a decremented count of morale cards in the row for morale units" do
      expect( subject.morale_boosts_for( morale1 ) ).to eq 1
      expect( subject.morale_boosts_for( morale2 ) ).to eq 1
    end
  end

  describe "#tight_bonds_for( card )" do
    let(:bond1) { create(:tight_bond, name: "James 1/2") }
    let(:bond2) { create(:tight_bond, name: "James 2/2") }
    let(:other_bond) { create(:tight_bond, name: "Steve 2/2") }
    subject { side_one.melee_row }
    before do
      side_one.card_plays.create(board_row: subject, card: regular_unit )
      side_one.card_plays.create(board_row: subject, card: bond1 )
      side_one.card_plays.create(board_row: subject, card: bond2 )
    end
    it "returns 0 for cards that don't have the Tight Bond ability" do
      expect( subject.tight_bonds_for( regular_unit ) ).to eq 0
    end
    it "returns a count of related Tight Bond cards in the row" do
      expect( subject.tight_bonds_for( bond1 ) ).to eq 1
      expect( subject.tight_bonds_for( bond2 ) ).to eq 1
    end
    it "excludes the card itself from the count" do
      expect( subject.tight_bonds_for( other_bond ) ).to eq 0
    end
  end
end

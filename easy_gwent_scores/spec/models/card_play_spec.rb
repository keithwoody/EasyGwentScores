require 'rails_helper'

RSpec.describe CardPlay, type: :model do
  it { is_expected.to belong_to(:board_side) }
  it { is_expected.to belong_to(:board_row) }
  it { is_expected.to belong_to(:card) }

  let(:side_one) { create(:board_side) }
  let(:row) { side_one.melee_row }
  let(:unit5) { create(:unit, strength: 5) }
  describe "Callbacks:" do
    describe "after_create" do
      let(:row_play) { build(:card_play, board_side: side_one, board_row: row, card: unit5) }
      it "updates the row's score if it was affected by the play" do
        expect{ row_play.save }.to change{ row.reload.score }.from(0).to(5)
      end
    end
  end

  describe "#calculate_row_score" do
    before do
      side_one.ranged_row.card_plays.delete_all
      side_one.card_plays.create(board_row: side_one.siege_row, card: create(:unit, strength: 6))
      side_one.card_plays.create(board_row: side_one.siege_row, card: create(:hero, strength: 7))
    end
    let(:empty_row) { side_one.ranged_row }
    it "returns 0 for a row with no cards" do
      subject.board_row = empty_row
      expect( subject.board_row.cards ).to be_empty
      expect( subject.calculate_row_score ).to eq 0
    end
    let(:multi_card_row) { side_one.siege_row }
    it "returns the sum of row_scores for cards played in the row" do
      subject.board_row = multi_card_row
      expect( subject.board_row.cards.count ).to eq 2
      expect( subject.calculate_row_score ).to eq 13
    end
  end

end

require 'rails_helper'

RSpec.describe BoardSide, type: :model do
  it { is_expected.to belong_to(:round) }
  it { is_expected.to have_many(:board_rows) }
  it { should have_many :card_plays }
  it { should have_many :global_card_plays }
  describe "after_save" do
    subject { create(:board_side) }
    it "is expected to have exactly 3 rows" do
      expect( subject.board_rows.count ).to eq 3
    end
    it { should have_one(:melee_row) }
    it { should have_one(:ranged_row) }
    it { should have_one(:siege_row) }
  end
end

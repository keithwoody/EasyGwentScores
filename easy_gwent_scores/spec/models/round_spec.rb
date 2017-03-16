require 'rails_helper'

RSpec.describe Round, type: :model do
  it { is_expected.to have_many(:board_sides) }
  describe "after_save" do
    subject { create(:round) }
    it "should have exactly two sides" do
      expect( subject.board_sides.count ).to eq 2
    end
    it "has a side_one that is different from side_two" do
      expect( subject.side_one ).to_not eq subject.side_two
    end
  end
end

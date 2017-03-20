require 'rails_helper'

RSpec.describe Card, type: :model do
  subject { build(:card) }
  it { is_expected.to belong_to :faction }
  describe "Validations" do
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:name) }
  end
  describe "after_create" do
    subject { create(:card) }
    it "has a default strength" do
      expect( subject.reload.strength ).to eq 0
    end
  end
  describe "#row_score" do
    subject { create(:card, strength: 0) }
    it "defaults to value of strength" do
      expect( subject.row_score(nil) ).to eq subject.strength
    end
    context "when weather effects are active" do
      let(:row) { build(:board_row, weather_active: true) }
      it "leaves cards with 0 strength unchanged" do
        expect( subject.strength ).to eq 0
        expect( subject.row_score( row ) ).to eq 0
      end
      it "reduces Unit strength to 1" do
        subject.update(card_type: 'Unit', strength: 2)
        expect( subject.row_score(row) ).to eq 1
      end
      it "leave Hero strength unaffected" do
        subject.update(card_type: 'Hero', strength: 2)
        expect( subject.row_score(row) ).to eq 2
      end
    end
  end
end

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
  describe "#row_score(row)" do
    subject { create(:unit, strength: 5) }
    let(:hero) { create(:hero, strength: 10) }
    let(:row) { build(:board_row) }
    it "defaults to value of strength" do
      expect( subject.row_score(row) ).to eq subject.strength
    end

    context "when weather effects are active" do
      let(:row) { build(:board_row, weather_active: true) }
      it "leaves cards with 0 strength unchanged" do
        subject.strength = 0
        expect( subject.row_score( row ) ).to eq 0
      end
      it "reduces Unit strength to 1" do
        subject.update(card_type: 'Unit', strength: 2)
        expect( subject.row_score(row) ).to eq 1
      end
      it "leaves Hero strength unaffected" do
        expect( hero.row_score(row) ).to eq hero.strength
      end
    end

    context "when Morale Boost ability is present" do
      it "adds boost count to each unit" do
        allow(row).to receive(:morale_boosts_for).with(subject).and_return(1)
        expect( subject.row_score(row) ).to eq( subject.strength + 1 )
      end
      it "leaves Hero strength unaffected" do
        expect( hero.row_score(row) ).to eq hero.strength
      end
    end

    context "when commander's horn is active" do
      let(:row) { build(:board_row, commanders_horn_active: true) }
      it "leaves cards with 0 strength unchanged" do
        subject.strength = 0
        expect( subject.row_score( row ) ).to eq 0
      end
      it "doubles Unit strength" do
        subject.update(card_type: 'Unit', strength: 2)
        expect( subject.row_score(row) ).to eq 4
      end
      it "leaves Hero strength unaffected" do
        expect( hero.row_score(row) ).to eq hero.strength
      end
    end
  end
end

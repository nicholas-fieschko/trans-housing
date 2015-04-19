require 'rails_helper'
RSpec.describe Location, type: :model do

  it "has a valid fabricator" do
    expect(Fabricate(:location)).to be_valid
  end

  describe "during creation" do
    describe "with valid input" do
      it "is valid with both a latitude and a longitude" do
        expect(Fabricate(:location, lat: 10, lng: 10)).to be_valid
      end
    end
    describe "with invalid input" do
      # Validating array members is difficult. Come back to this.
      # it "is not valid without a longitude" do
      #   expect(Fabricate(:location, lng: nil)).to_not be_valid
      # end
      # it "is not valid without a latitude" do
      #   expect(Fabricate(:location, lat: nil)).to_not be_valid
      # end
    end
  end

end
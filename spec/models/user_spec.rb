require 'rails_helper'

RSpec.describe User, type: :model do

  it "has a valid fabricator" do
    expect(Fabricate(:user)).to be_valid
  end

  describe "when creating a user" do

    context "given valid credentials" do

      it "is valid with just one contact method, an email address" do
        expect(Fabricate.build(:user, contact: Fabricate.build(:email_only))).to be_valid
      end

      it "is valid with just one contact method, a phone number" do
        expect(Fabricate.build(:user, contact: Fabricate.build(:phone_only))).to be_valid
      end
    end

    context "given invalid credentials" do 

      it "is invalid without a name" do
        expect(Fabricate.build(:user, name: nil)).to_not be_valid
      end
      it "is invalid without at least one contact method" do
        expect(Fabricate.build(:user, contact: Fabricate.build(:phone_only, phone: nil))).to_not be_valid
        expect(Fabricate.build(:user, contact: nil)).to_not be_valid
      end
      it "is invalid without specifying trans status"
      it "is invalid without a gender"

      it "cannot have the same email as someone else"
      it "cannot have the same phone number as someone else"

    end
  end
end

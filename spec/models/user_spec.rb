require 'rails_helper'

RSpec.describe User, type: :model do

  it "has a valid fabricator" do
    expect(Fabricate(:user)).to be_valid
  end

  describe "creation," do

    describe "given valid credentials" do

      it "is valid with just one contact method: an email address" do
        expect(Fabricate.build(:user, contact: Fabricate.build(:email_only))).to be_valid
      end

      it "is valid with just one contact method: a phone number" do
        expect(Fabricate.build(:user, contact: Fabricate.build(:phone_only))).to be_valid
      end

      it "saves the email address in all lowercase" do
        user = Fabricate(:user, contact: Fabricate.build(:contact, email: "TEST@TEST.com"))
        expect(user.contact.email).to eq("test@test.com")
      end

    end

    describe "given invalid credentials" do 

      it "is invalid without a name" do
        expect(Fabricate.build(:user, name: nil)).to_not be_valid
      end

      describe "for contact information" do
        it "is invalid with no contact profile" do
          expect(Fabricate.build(:user, contact: nil)).to_not be_valid
        end

        it "is invalid without at least one contact method" do
          expect(Fabricate.build(:user, contact: Fabricate.build(:contact, email: nil, phone: nil))).to_not be_valid
        end
      end

      describe "for gender information" do
         it "is invalid without a gender" do
          expect(Fabricate.build(:user, gender: nil)).to_not be_valid
        end
        it "is invalid without specifying trans status" do
          expect(Fabricate.build(:user, gender: Fabricate.build(:binary_gender, trans: nil))).to_not be_valid
        end

        it "is not able to set the custom pronouns option to 'true' if not trans" do
          expect(Fabricate.build(:user, gender: Fabricate.build(:binary_gender, cp:true))).to_not be_valid
        end

        it "is not able to set custom pronouns of any tense (they,them,their) if not trans" do
          expect(Fabricate.build(:user, gender: Fabricate.build(:binary_gender, they:"They"))).to_not be_valid
          expect(Fabricate.build(:user, gender: Fabricate.build(:binary_gender, them:"Them"))).to_not be_valid
          expect(Fabricate.build(:user, gender: Fabricate.build(:binary_gender, their:"Their"))).to_not be_valid
        end
      end
     
      # it "is invalid if signing up with an existing email"
      # it "is invalid if signing up with an existing phone number"

    end
  end
end

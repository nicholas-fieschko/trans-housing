require 'rails_helper'

RSpec.describe User, type: :model do

  it "has a valid fabricator" do
    expect(Fabricate(:user)).to be_valid
  end

  describe "creating an account" do

    describe "given valid credentials" do

      describe "for contact information" do
        
        it "is valid with just one contact method: an email address" do
          expect(Fabricate.build(:user, contact: Fabricate.build(:email_only))).to be_valid
        end

        it "is valid with just one contact method: a phone number" do
          expect(Fabricate.build(:user, contact: Fabricate.build(:phone_only))).to be_valid
        end

        it "converts and saves the email address in all lowercase" do
          user = Fabricate(:user, contact: Fabricate.build(:contact, email: "TEST@TEST.com"))
          expect(user.contact.email).to eq("test@test.com")
        end
      end

      describe "for gender information" do
        context "as a nonbinary trans person" do
          it "is valid with custom pronouns" do
            expect(Fabricate.build(:custom_pronoun_user)).to be_valid
          end
          it "is valid without custom pronouns" do
            expect(Fabricate.build(:user, gender: Fabricate.build(:nonbinary_gender, 
                                     cp: false, they: nil, their: nil, them: nil))).to be_valid
          end


          it "converts and saves gender identity in all lowercase" do
            user = Fabricate(:nonbinary_user, 
                   gender: Fabricate.build(:nonbinary_gender, identity: "GENDERFLUID"))
            expect(user.gender[:identity]).to eq("genderfluid")
          end

          it "converts and saves custom pronouns in all lowercase" do
            user = Fabricate(:custom_pronoun_user, 
                   gender: Fabricate.build(:custom_pronoun_gender,
                            they: "XE", them: "HIR", their: "HIR"))
            expect(user.gender[:they]).to eq("xe")
            expect(user.gender[:them]).to eq("hir")
            expect(user.gender[:their]).to eq("hir")
          end

        end
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

        context "as a cis person" do
          it "is invalid if claiming need for custom pronouns" do
            expect(Fabricate.build(:user, gender: Fabricate.build(:binary_gender, cp:true))).to_not be_valid
          end

          it "is invalid if setting custom pronouns of any tense (they,them,their)" do
            expect(Fabricate.build(:user, gender: Fabricate.build(:binary_gender, they:"They"))).to_not be_valid
            expect(Fabricate.build(:user, gender: Fabricate.build(:binary_gender, them:"Them"))).to_not be_valid
            expect(Fabricate.build(:user, gender: Fabricate.build(:binary_gender, their:"Their"))).to_not be_valid
          end
        end

        context "as a nonbinary trans person" do
          it "is invalid if claims need for custom pronouns but does not specify them all" do
            expect(Fabricate.build(:nonbinary_user, gender: Fabricate.build(:custom_pronoun_gender, they: nil))).to_not be_valid
            expect(Fabricate.build(:nonbinary_user, gender: Fabricate.build(:custom_pronoun_gender, them: nil))).to_not be_valid
            expect(Fabricate.build(:nonbinary_user, gender: Fabricate.build(:custom_pronoun_gender, their: nil))).to_not be_valid
          end
        end
      end
     
      it "is invalid if signing up with an existing email" do
        Fabricate(:user, contact: Fabricate.build(:contact, email: "TEST@TEST.com"))
        expect(Fabricate.build(:user, contact: Fabricate.build(:contact, email: "TEST@TEST.com"))).to_not be_valid
      end
      it "is invalid if signing up with an existing phone number" do
        Fabricate(:user, contact: Fabricate.build(:contact, phone: "111-111-1111"))
        expect(Fabricate.build(:user, contact: Fabricate.build(:contact, phone: "111-111-1111"))).to_not be_valid
      end
    end
  end

  describe "deleting a user" do
    it "destroys contact information" do
      user = Fabricate(:user)
      expect { user.destroy }.to change { Contact.count }.by(-1)
    end
    it "destroys location information" do
      user = Fabricate(:user)
      expect { user.destroy }.to change { Location.count }.by(-1)
    end
  end

  describe "pronoun getters .they, .them, .their" do

    describe "for a binary male user" do
      user = Fabricate.build(:user, 
             gender: Fabricate.build(:binary_gender, identity: "male"))
      it "returns 'he' as the 'they' tense" do 
        expect(user.they).to eq "he"
      end
      it "returns 'him' as the 'them' tense" do 
        expect(user.them).to eq "him"
      end
      it "returns 'his' as the 'their' tense" do 
        expect(user.their).to eq "his"
      end
    end

    describe "for a binary female user" do
      user = Fabricate.build(:user, 
             gender: Fabricate.build(:binary_gender, identity: "female"))
      it "returns 'she' as the 'they' tense" do 
        expect(user.they).to eq "she"
      end
      it "returns 'her' as the 'them' tense" do 
        expect(user.them).to eq "her"
      end
      it "returns 'her' as the 'their' tense" do 
        expect(user.their).to eq "her"
      end
    end

    describe "for a nonbinary user without custom pronouns" do
      user = Fabricate.build(:nonbinary_user, 
             gender: Fabricate.build(:nonbinary_gender, cp: false))
      it "returns 'they' as the 'they' tense" do 
        expect(user.they).to eq "they"
      end
      it "returns 'them' as the 'them' tense" do 
        expect(user.them).to eq "them"
      end
      it "returns 'their' as the 'their' tense" do 
        expect(user.their).to eq "their"
      end
    end

    describe "for a nonbinary user with custom pronouns xe, hir, hir" do
      user = Fabricate.build(:custom_pronoun_user, 
             gender: Fabricate.build(:custom_pronoun_gender,
             they:            "xe",
             them:            "hir",
             their:           "hir"))
      it "returns 'xe' as the 'they' tense" do 
        expect(user.they).to eq "xe"
      end
      it "returns 'hir' as the 'them' tense" do 
        expect(user.them).to eq "hir"
      end
      it "returns 'hir' as the 'their' tense" do 
        expect(user.their).to eq "hir"
      end
    end
  end

  describe "provider/seeker status getters .provider?, .seeker?" do
    describe ".provider?" do
      it "returns true if user is a provider and false if a seeker" do
        expect(Fabricate.build(:provider).provider?).to eq true
        expect(Fabricate.build(:seeker).provider?).to eq false
      end
    end
    describe ".seeker?" do
      it "returns true if user is a seeker and false if a provider" do
        expect(Fabricate.build(:seeker).seeker?).to eq true
        expect(Fabricate.build(:provider).seeker?).to eq false
      end
    end
  end

  describe "needed/offered resource getters" do 
    describe ".food?" do
      it "returns true for a user needing or offering food" do
        user = Fabricate.build(:user, 
                         food_resource: Fabricate.build(:food_resource,
                         currently_offered: true))
        expect(user.food?).to eq true
      end
      it "returns false for a user not needing or offering food" do
        user = Fabricate.build(:user, 
                         food_resource: Fabricate.build(:food_resource,
                         currently_offered: false))
        expect(user.food?).to eq false
      end
    end
    describe ".shower?" do
      it "returns true for a user needing or offering shower access" do
        user = Fabricate.build(:user, 
                         shower_resource: Fabricate.build(:shower_resource,
                         currently_offered: true))
        expect(user.shower?).to eq true
      end
      it "returns false for a user not needing or offering shower access" do
        user = Fabricate.build(:user, 
                         shower_resource: Fabricate.build(:shower_resource,
                         currently_offered: false))
        expect(user.shower?).to eq false
      end
    end
    describe ".laundry?" do
      it "returns true for a user needing or offering laundry service" do
        user = Fabricate.build(:user, 
                         laundry_resource: Fabricate.build(:laundry_resource,
                         currently_offered: true))
        expect(user.laundry?).to eq true
      end
      it "returns false for a user not needing or offering laundry service" do
        user = Fabricate.build(:user, 
                         laundry_resource: Fabricate.build(:laundry_resource,
                         currently_offered: false))
        expect(user.laundry?).to eq false
      end
    end
    describe ".housing?" do
      it "returns true for a user needing or offering housing" do
        user = Fabricate.build(:user, 
                         housing_resource: Fabricate.build(:housing_resource,
                         currently_offered: true))
        expect(user.housing?).to eq true
      end
      it "returns false for a user not needing or offering housing" do
        user = Fabricate.build(:user, 
                         housing_resource: Fabricate.build(:housing_resource,
                         currently_offered: false))
        expect(user.housing?).to eq false
      end
    end
    describe ".transportation?" do
      it "returns true for a user needing or offering transportation help" do
        user = Fabricate.build(:user, 
                         transportation_resource: Fabricate.build(:transportation_resource,
                         currently_offered: true))
        expect(user.transportation?).to eq true
      end
      it "returns false for a user not needing or offering transportation help" do
        user = Fabricate.build(:user, 
                         transportation_resource: Fabricate.build(:transportation_resource,
                         currently_offered: false))
        expect(user.transportation?).to eq false
      end
    end
    describe ".buddy?" do
      it "returns true for a user needing a or offering to be a buddy" do
        user = Fabricate.build(:user, 
                         buddy_resource: Fabricate.build(:buddy_resource,
                         currently_offered: true))
        expect(user.buddy?).to eq true
      end
      it "returns false for a user not needing a or offering to be a buddy" do
        user = Fabricate.build(:user, 
                         buddy_resource: Fabricate.build(:buddy_resource,
                         currently_offered: false))
        expect(user.buddy?).to eq false
      end
    end
    describe ".misc?" do
      it "returns true for a user needing or offering miscellaneous help" do
        user = Fabricate.build(:user, 
                         misc_resource: Fabricate.build(:misc_resource,
                         currently_offered: true))
        expect(user.misc?).to eq true
      end
      it "returns false for a user not needing a or offering to be a misc" do
        user = Fabricate.build(:user, 
                         misc_resource: Fabricate.build(:misc_resource,
                         currently_offered: false))
        expect(user.misc?).to eq false
      end
    end
  end
end

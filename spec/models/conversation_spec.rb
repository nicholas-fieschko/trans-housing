require 'rails_helper'

RSpec.describe Conversation, type: :model do

	describe "behavior with proper fields" do
	
		it "should exist in MongoDB" do
			expect(Fabricate.build(:conversation)).to be_valid
		end

		it "should do thing z" do
		end
	end

	describe "sorting" do
		it "should display messages in reverser chron order" do
		end
	end

end

require 'rails_helper'

RSpec.describe User, type: :model do

  it "has a valid fabricator" do
    Fabricate(:user).should be_valid
  end


end

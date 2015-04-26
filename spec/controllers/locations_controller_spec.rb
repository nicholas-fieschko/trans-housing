require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
  describe "POST #location/post" do
    it "responds successfully with an HTTP 200 status" do
      post :location/post
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end
end

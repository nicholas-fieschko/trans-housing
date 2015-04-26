require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
	describe "POST #location/posts" do
		it "responds successfully with an HTTP 201 status" do
		post :location/posts
		expect(response).to be_success
		expect(response).to have_http_status(201)
		end
	end
end

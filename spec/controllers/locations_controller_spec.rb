require 'rails_helper'

RSpec.describe LocationsController, :type => :controller do
	describe "GET index" do
		it "has a 200 status code" do
			get :index
			expect(response.status).to eq(200)
		end
	end

	it "renders the index template" do
	    get :index
		expect(response).to render_template("index")
	end
	# describe "POST #location/posts" do
	# 	it "responds successfully with an HTTP 201 status" do
	# 	post :location/posts
	# 	expect(response).to be_success
	# 	expect(response).to have_http_status(201)
	# 	end
	# end
end

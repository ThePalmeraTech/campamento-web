require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /el_coding_challenge" do
    it "returns http success" do
      get "/pages/el_coding_challenge"
      expect(response).to have_http_status(:success)
    end
  end

end

require 'rails_helper'

RSpec.describe Api::TestsController, type: :controller do
  render_views

  context 'Tests Index' do
    it 'should return success' do
      get :index, params: {}, format: :json
      json_response = JSON.parse(response.body)
      expect(json_response['response']).to be_present
    end
  end
end

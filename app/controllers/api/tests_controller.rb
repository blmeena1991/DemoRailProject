class Api::TestsController < Api::ApiController

  def index
    render json: { response: "demo" }, status: :ok
  end
end
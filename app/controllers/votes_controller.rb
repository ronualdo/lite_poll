class VotesController < ApplicationController
  def create
    response = { option_id: 1, user: 'random user' }
    render json: response, status: 200
  end
end

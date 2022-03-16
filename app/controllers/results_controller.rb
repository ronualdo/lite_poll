# frozen_string_literal: true

class ResultsController < ApplicationController
  def index
    response = {
      post_id: 1,
      results: [
        { option_id: 1, value: '0.94' },
        { optioin_id: 2, value: '0.06' }
      ]
    }

    render json: response, status: 200
  end
end

# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from StandardError do |error|
    render json: { errors: [error.message] }, status: :internal_server_error
  end
end

# frozen_string_literal: true

class ApplicationController < ActionController::API
  after_action :set_headers

  rescue_from StandardError do |error|
    render json: { errors: [error.message] }, status: :internal_server_error
  end

  private

  def set_headers
    headers['Connection'] = 'Keep-Alive'
    headers['Keep-Alive'] = 'timeout=65, max=1000'
  end
end

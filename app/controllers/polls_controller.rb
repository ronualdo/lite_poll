# frozen_string_literal: true

class PollsController < ApplicationController
  def show
    poll = Poll.find_by(id: params[:id])

    if poll
      render json: poll, status: :ok
    else
      render json: { errors: ['Not found'] }, status: :not_found
    end
  end

  def create
    new_poll = Poll.new(poll_params)

    if new_poll.save
      render json: new_poll, status: :created
    else
      render json: new_poll, status: :unprocessable_entity
    end
  end

  def poll_params
    params.require(:poll).permit(:question, options_attributes: [:label])
  end
end

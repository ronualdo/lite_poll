# frozen_string_literal: true

class VotesController < ApplicationController
  def create
    option = Option.find_by(id: vote_params[:option_id])
    render json: { errors: ['Option not found'] }, status: :not_found and return if option.nil?

    vote = option.add_vote(vote_params[:user])

    if vote.save
      render json: vote, status: :created
    else
      render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:user, :option_id)
  end
end

# frozen_string_literal: true

class ResultsController < ApplicationController
  def index
    poll = Poll.find_by(id: params[:poll_id])
    render json: { errors: ['Poll not found'] }, status: :not_found and return if poll.nil?

    render json: build_result(poll), status: 200
  end

  private

  def build_result(poll)
    {
      poll_id: poll.id,
      question: poll.question,
      results: poll.options.map do |option|
        { label: option.label, option_id: option.id, value: number_of_votes(option) }
      end
    }
  end

  def number_of_votes(option)
    Vote.where(option: option).count
  end
end

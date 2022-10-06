# frozen_string_literal: true

class PollsController < ApplicationController
  def create
    render json: double_poll, status: :created
  end

  def show
    render json: double_poll, status: 200
  end

  private

  def double_poll
    {
      id: 1,
      question: 'what is the best console?',
      options: [
        { id: 1, label: 'playstation' },
        { id: 2, label: 'xbox' }
      ]
    }
  end
end

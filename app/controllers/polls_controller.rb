class PollsController < ApplicationController
  def show
    double_poll = {
      id: 1,
      question: 'what is the best console?',
      options: [
        { id: 1, label: 'playstation', result: '0.95' },
        { id: 2, label: 'xbox', result: '0.05' }
      ]
    }
    render json: double_poll, status: 200
  end
end

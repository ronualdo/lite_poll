# frozen_string_literal: true

class Option < ApplicationRecord
  belongs_to :poll

  has_many :votes

  def add_vote(user)
    votes.build(user: user)
  end
end

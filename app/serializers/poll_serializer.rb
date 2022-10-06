# frozen_string_literal: true

class PollSerializer < ActiveModel::Serializer
  attributes :id, :question

  has_many :options
end

# frozen_string_literal: true

class VoteSerializer < ActiveModel::Serializer
  attributes :id, :option_id, :user
end

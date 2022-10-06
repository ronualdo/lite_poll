# frozen_string_literal: true

class Poll < ApplicationRecord
  has_many :options, dependent: :destroy

  accepts_nested_attributes_for :options
end

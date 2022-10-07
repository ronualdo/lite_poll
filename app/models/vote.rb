# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :option

  validates_presence_of :user
end

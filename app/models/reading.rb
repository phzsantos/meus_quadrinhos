# frozen_string_literal: true

class Reading < ApplicationRecord
  belongs_to :comic
  validates :read_at, presence: true
end

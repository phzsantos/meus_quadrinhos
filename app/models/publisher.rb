# frozen_string_literal: true

class Publisher < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true
end

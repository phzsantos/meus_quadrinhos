# frozen_string_literal: true

class BookBinding < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  validates :name, presence: true
end

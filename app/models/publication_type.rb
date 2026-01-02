# frozen_string_literal: true

class PublicationType < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  validates :name, presence: true
end

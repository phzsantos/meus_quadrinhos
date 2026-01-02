# frozen_string_literal: true

class PaperType < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :comics, dependent: :restrict_with_error

  validates :name, presence: true
end

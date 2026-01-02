# frozen_string_literal: true

class Publisher < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :comics, dependent: :restrict_with_error

  validates :name, presence: true

  def should_generate_new_friendly_id?
    name_changed?
  end
end

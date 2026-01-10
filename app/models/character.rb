# frozen_string_literal: true

class Character < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :comic_characters, dependent: :restrict_with_error
  has_many :comics, through: :comic_characters

  validates :name, presence: true

  def should_generate_new_friendly_id?
    name_changed?
  end
end

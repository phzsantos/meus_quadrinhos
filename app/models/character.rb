# frozen_string_literal: true

class Character < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  validates :name, presence: true

  def should_generate_new_friendly_id?
    name_changed?
  end
end

# frozen_string_literal: true

class Collection < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :comics, dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def should_generate_new_friendly_id?
    name_changed?
  end
end

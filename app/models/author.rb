# frozen_string_literal: true

class Author < ApplicationRecord
  extend FriendlyId
  include CatalogVisibility

  friendly_id :name, use: :slugged

  has_many :comic_authors, dependent: :restrict_with_error
  has_many :comics, through: :comic_authors

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def should_generate_new_friendly_id?
    name_changed?
  end
end

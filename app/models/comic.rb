# frozen_string_literal: true

class Comic < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged

  belongs_to :publisher
  belongs_to :publication_type
  belongs_to :book_binding
  belongs_to :paper_type

  has_many :comic_authors, dependent: :restrict_with_error
  has_many :authors, through: :comic_authors

  has_one_attached :cover_image

  validates :title, presence: true
  validates :page_count, numericality: { greater_than: 0 }, presence: true
  validates :published_year, numericality: { only_integer: true }, presence: true

  def should_generate_new_friendly_id?
    title_changed?
  end

  before_validation :remove_blank_author_ids

  private

  def remove_blank_author_ids
    self.author_ids = author_ids.reject(&:blank?) if author_ids
  end
end

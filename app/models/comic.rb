# frozen_string_literal: true

class Comic < ApplicationRecord
  extend FriendlyId

  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    if collection.present?
      [
        [:title, :issue_number],
      ]
    else
      [
        :title,
      ]
    end
  end

  def display_title
    if collection.present?
      "#{title} n° #{issue_number}"
    else
      title
    end
  end

  belongs_to :publisher
  belongs_to :publication_type
  belongs_to :book_binding
  belongs_to :paper_type
  belongs_to :collection, optional: true

  has_many :comic_authors, dependent: :destroy
  has_many :authors, through: :comic_authors

  has_many :comic_characters, dependent: :destroy
  has_many :characters, through: :comic_characters

  has_many :readings, dependent: :destroy
  accepts_nested_attributes_for :readings,
    allow_destroy: true,
    reject_if: :reading_blank?

  has_one_attached :cover_image

  validates :title, presence: true
  validates :page_count, numericality: { greater_than: 0 }, presence: true
  validates :published_year, numericality: { only_integer: true }, presence: true

  def should_generate_new_friendly_id?
    title_changed? || issue_number_changed?
  end

  before_validation :remove_blank_author_ids

  private

  def remove_blank_author_ids
    self.author_ids = author_ids.reject(&:blank?) if author_ids
  end

  def reading_blank?(attrs)
    attrs["read_at"].blank? && attrs["_destroy"] != "1"
  end
end

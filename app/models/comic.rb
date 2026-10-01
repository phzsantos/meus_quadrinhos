# frozen_string_literal: true

class Comic < ApplicationRecord
  extend FriendlyId

  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    if collection.present?
      [
        [:title, :issue_number, :published_year],
      ]
    else
      [
        [:title, :published_year],
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

  has_many :user_comics, dependent: :destroy
  has_many :owners, through: :user_comics, source: :user

  has_one_attached :cover_image

  scope :visible_to, lambda { |user|
    return none if user.blank?
    return all if user.admin?

    owned_ids = UserComic.where(user_id: user.id).select(:comic_id)
    read_ids = Reading.where(user_id: user.id).where.not(read_at: nil).select(:comic_id)

    where(id: owned_ids).or(where(id: read_ids))
  }

  validates :title, presence: true, uniqueness: { scope: [:issue_number, :published_year], case_sensitive: false }
  validates :page_count, numericality: { greater_than: 0 }, presence: true
  validates :published_year, numericality: { only_integer: true }, presence: true
  validates :story_count, numericality: { only_integer: true, greater_than: 0 }, presence: true
  validates :authors, presence: true
  validates :characters, presence: true
  validates :issue_number, numericality: { only_integer: true }, presence: true

  def should_generate_new_friendly_id?
    title_changed? || issue_number_changed? || published_year_changed?
  end

  def owned_by?(user)
    return false if user.blank?

    if user_comics.loaded?
      user_comics.any? { |uc| uc.user_id == user.id }
    else
      user_comics.exists?(user_id: user.id)
    end
  end

  def read_by?(user)
    return false if user.blank?

    if readings.loaded?
      readings.any? { |r| r.user_id == user.id && r.read_at.present? }
    else
      readings.where(user_id: user.id).where.not(read_at: nil).exists?
    end
  end

  def readings_for(user)
    readings.where(user_id: user.id)
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

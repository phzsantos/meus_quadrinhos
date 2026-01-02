# frozen_string_literal: true

class Comic < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged

  belongs_to :author
  belongs_to :publisher
  belongs_to :publication_type
  belongs_to :book_binding
  belongs_to :paper_type

  validates :title, presence: true
  validates :page_count, numericality: { greater_than: 0 }, presence: true
  validates :published_year, numericality: { only_integer: true }, presence: true
end

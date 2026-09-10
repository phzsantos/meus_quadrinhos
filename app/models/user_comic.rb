# frozen_string_literal: true

class UserComic < ApplicationRecord
  belongs_to :user
  belongs_to :comic

  validates :comic_id, uniqueness: { scope: :user_id }
end

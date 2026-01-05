# frozen_string_literal: true

class ComicAuthor < ApplicationRecord
  belongs_to :comic
  belongs_to :author
end

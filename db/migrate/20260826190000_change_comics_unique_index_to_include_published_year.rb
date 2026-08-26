# frozen_string_literal: true

class ChangeComicsUniqueIndexToIncludePublishedYear < ActiveRecord::Migration[7.1]
  def change
    remove_index(:comics, [:title, :issue_number], name: "index_comics_on_title_and_issue_number")
    add_index(:comics, [:title, :issue_number, :published_year], unique: true)
  end
end

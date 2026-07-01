# frozen_string_literal: true

class AddUniqueIndexToComicsTitleAndIssueNumber < ActiveRecord::Migration[7.1]
  def change
    add_index(:comics, [:title, :issue_number], unique: true)
  end
end

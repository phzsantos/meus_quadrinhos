# frozen_string_literal: true

class AddNotNullToIssueNumber < ActiveRecord::Migration[7.1]
  def change
    change_column_null(:comics, :issue_number, false)
  end
end

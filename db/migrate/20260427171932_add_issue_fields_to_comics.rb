# frozen_string_literal: true

class AddIssueFieldsToComics < ActiveRecord::Migration[7.1]
  def change
    change_table(:comics, bulk: true) do |t|
      t.integer(:issue_number)
      t.string(:issue_title)
    end

    add_index(:comics, :issue_number)
  end
end

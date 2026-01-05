# frozen_string_literal: true

class RemoveAuthorFromComics < ActiveRecord::Migration[7.1]
  def change
    remove_reference(:comics, :author, null: false, foreign_key: true, type: :uuid)
  end
end

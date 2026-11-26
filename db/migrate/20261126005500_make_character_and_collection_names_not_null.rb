# frozen_string_literal: true

class MakeCharacterAndCollectionNamesNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null(:characters, :name, false)
    change_column_null(:collections, :name, false)
  end
end

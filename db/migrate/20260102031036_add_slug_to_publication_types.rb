# frozen_string_literal: true

class AddSlugToPublicationTypes < ActiveRecord::Migration[7.1]
  def change
    add_column(:publication_types, :slug, :string)
    add_index(:publication_types, :slug, unique: true)
  end
end

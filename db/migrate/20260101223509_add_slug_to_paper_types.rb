# frozen_string_literal: true

class AddSlugToPaperTypes < ActiveRecord::Migration[7.1]
  def change
    add_column(:paper_types, :slug, :string)
    add_index(:paper_types, :slug, unique: true)
  end
end

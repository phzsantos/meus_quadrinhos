# frozen_string_literal: true

class AddLinkGuiaDosQuadrinhosToCollections < ActiveRecord::Migration[7.1]
  def change
    add_column(:collections, :link_guia_dos_quadrinhos, :string)
  end
end

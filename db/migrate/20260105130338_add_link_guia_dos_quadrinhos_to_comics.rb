# frozen_string_literal: true

class AddLinkGuiaDosQuadrinhosToComics < ActiveRecord::Migration[7.1]
  def change
    add_column(:comics, :link_guia_dos_quadrinhos, :string)
  end
end

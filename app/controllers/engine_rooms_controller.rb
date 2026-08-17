# frozen_string_literal: true

class EngineRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def show
    @stats = [
      { label: "Quadrinhos", count: Comic.count, path: comics_path },
      { label: "Coleções", count: Collection.count, path: collections_path },
      { label: "Autores", count: Author.count, path: authors_path },
      { label: "Personagens", count: Character.count, path: characters_path },
      { label: "Editoras", count: Publisher.count, path: publishers_path },
      { label: "Encadernações", count: BookBinding.count, path: book_bindings_path },
      { label: "Tipos de papel", count: PaperType.count, path: paper_types_path },
      { label: "Tipos de HQ", count: PublicationType.count, path: publication_types_path },
    ]
  end
end

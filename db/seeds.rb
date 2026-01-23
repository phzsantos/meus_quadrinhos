# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "json"

publishers = [
  "Abril",
  "Mythos",
  "Devir",
  "Panini",
  "JBC",
  "Comix Zone",
  "Globo",
  "Record",
  "Pipoca & Nanquim",
  "Alta Geek",
]

publishers.each do |name|
  Publisher.find_or_create_by!(name: name)
end

book_bindings = [
  "Capa dura",
  "Capa cartão",
  "Canoa",
  "Omnibus",
]

book_bindings.each do |name|
  BookBinding.find_or_create_by!(name: name)
end

paper_types = [
  "Couché",
  "Offset",
  "LWC",
  "Jornal",
]

paper_types.each do |name|
  PaperType.find_or_create_by!(name: name)
end

authors = [
  "Alan Moore",
  "Frank Miller",
  "Garth Ennis",
  "Mark Millar",
  "Jason Aaron",
  "Matthew Rosenberg",
  "Gerry Duggan",
  "Dan Abnett",
  "Greg Rucka",
  "Steven Grant",
  "Mike Baron",
  "David Pepose",
  "Chuck Dixon",
  "Howard Mackie",
  "Nathan Edmondson",
  "Dan D. G. Chichester",
  "Andy Lanning",
  "Mark Waid",
  "Torunn Grønbekk",
  "Gerry Conway",
  "Margaret Clark",
  "Grant Morrison",
  "Dan Jurgens",
  "Paul Jenkins",
  "Kevin Maurer",
  "Mauro Boselli",
]

authors.each do |name|
  Author.find_or_create_by!(name: name)
end

publication_types = [
  "HQ",
  "Mangá",
  "Manhwa",
  "Manhua",
]

characters = [
  "Justiceiro",
  "Capitão América",
  "Homem-Aranha",
  "Thor",
  "Motoqueiro Fantasma",
  "Wolverine",
  "Superman",
  "Tex Willer",
  "Hulk",
  "Demolidor",
  "Cavaleiro da Lua",
  "Doutor Estranho",
  "Homem de Ferro",
  "Batman",
  "Lex Luthor",
  "Viuva Negra",
  "Reed Richards",
  "Sue Storm",
  "Johnny Storm",
  "Ben Grimm",
  "V",
]

characters.each do |name|
  Character.find_or_create_by!(name: name)
end

publication_types.each do |name|
  PublicationType.find_or_create_by!(name: name)
end

collections = [
  { name: "Marvel Deluxe: Justiceiro", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/capas/marvel-deluxe-justiceiro/ma011157" },
  { name: "Justiceiro 2ª Série", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/capas/justiceiro-2-serie/ju011200" },
  { name: "Justiceiro 3ª Série", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/capas/justiceiro-3-serie/ju011300" },
  { name: "Justiceiro 4ª Série", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/capas/justiceiro-4-serie/ju011400" },
  { name: "Justiceiro Por Greg Rucka", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/capas/justiceiro-por-greg-rucka/ju011128" },
  { name: "Justiceiro & Capitão América - Sangue e Glória", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/capas/justiceiro-e-capitao-america-sangue-e-gloria/jca0301" },
  { name: "Paladinos Marvel", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/capas/paladinos-marvel/pa011100" },
  { name: "Procurado", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/capas/procurado/wa062100" },
  { name: "Um Passeio No Inferno", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/capas/um-passeio-no-inferno/um237910" },
  { name: "As Aventuras de Tex Quando Jovem", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/capas/tex-willer/te062124" },
  { name: "Thor, O Deus do Trovão", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/capas-estrangeiras/thor-god-of-thunder-(2013)/5208" },
]

collections.each do |collection|
  Collection.find_or_create_by!(name: collection[:name], link_guia_dos_quadrinhos: collection[:link_guia_dos_quadrinhos])
end

file_path = Rails.root.join("db/seeds/comics.json")

comics = JSON.parse(File.read(file_path), symbolize_names: true)

comics.each do |attrs|
  authors = attrs[:author_names].map do |name|
    Author.find_by!(name: name)
  end

  characters =
    if attrs[:character_names].present?
      attrs[:character_names].map { |name| Character.find_by!(name: name) }
    else
      []
    end

  collection =
    if attrs[:collection_name].present?
      Collection.find_by!(name: attrs[:collection_name])
    end

  publisher = Publisher.find_by!(name: attrs[:publisher_name])
  publication_type = PublicationType.find_by!(name: attrs[:publication_type_name])
  book_binding = BookBinding.find_by!(name: attrs[:book_binding_name])
  paper_type = PaperType.find_by!(name: attrs[:paper_type_name])

  comic = Comic.find_or_initialize_by(title: attrs[:title])

  comic.assign_attributes(
    page_count: attrs[:page_count],
    published_year: attrs[:published_year],
    publisher: publisher,
    publication_type: publication_type,
    book_binding: book_binding,
    paper_type: paper_type,
    collection: collection,
    story_count: attrs[:story_count],
    link_guia_dos_quadrinhos: attrs[:link_guia_dos_quadrinhos],
  )

  comic.authors = authors
  comic.characters = characters
  comic.save!

  Array(attrs[:read_dates]).each do |date|
    comic.readings.find_or_create_by!(read_at: date)
  end

  next if comic.cover_image.attached?

  filename = "#{comic.title}.jpg"
  path = Rails.root.join("app/assets/images/covers", filename)

  next unless File.exist?(path)

  comic.cover_image.attach(
    io: File.open(path),
    filename: filename,
    content_type: "image/jpeg",
  )
end

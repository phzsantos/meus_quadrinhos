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

file_path = Rails.root.join("db/seeds/publishers.json")

publishers = JSON.parse(File.read(file_path), symbolize_names: true)

publishers.each do |name|
  Publisher.find_or_create_by!(name: name)
end

file_path = Rails.root.join("db/seeds/book_bindings.json")

book_bindings = JSON.parse(File.read(file_path), symbolize_names: true)

book_bindings.each do |name|
  BookBinding.find_or_create_by!(name: name)
end

file_path = Rails.root.join("db/seeds/paper_types.json")

paper_types = JSON.parse(File.read(file_path), symbolize_names: true)

paper_types.each do |name|
  PaperType.find_or_create_by!(name: name)
end

file_path = Rails.root.join("db/seeds/authors.json")

authors = JSON.parse(File.read(file_path), symbolize_names: true)

authors.each do |name|
  Author.find_or_create_by!(name: name)
end

file_path = Rails.root.join("db/seeds/characters.json")

characters = JSON.parse(File.read(file_path), symbolize_names: true)

characters.each do |name|
  Character.find_or_create_by!(name: name)
end

file_path = Rails.root.join("db/seeds/publication_types.json")

publication_types = JSON.parse(File.read(file_path), symbolize_names: true)

publication_types.each do |name|
  PublicationType.find_or_create_by!(name: name)
end

file_path = Rails.root.join("db/seeds/collections.json")

collections = JSON.parse(File.read(file_path), symbolize_names: true)

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
  path = Rails.root.join("db/seeds/covers", filename)

  next unless File.exist?(path)

  comic.cover_image.attach(
    io: File.open(path),
    filename: filename,
    content_type: "image/jpeg",
  )
end

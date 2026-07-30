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

def load_seed(file)
  path = Rails.root.join("db", "seeds", file)
  abort("Seed não encontrado: #{file}") unless File.exist?(path)

  JSON.parse(File.read(path), symbolize_names: true)
end

{
  "publishers.json" => Publisher,
}.each do |file, model|
  load_seed(file).each do |name|
    model.find_or_create_by!(name: name)
  end
end

load_seed("comics.json").each do |attrs|
  comic = Comic.find_or_initialize_by(title: attrs[:title], issue_number: attrs[:issue_number])

  comic.assign_attributes(
    page_count: attrs[:page_count],
    published_year: attrs[:published_year],
    publisher: Publisher.find_by!(name: attrs[:publisher_name]),
    publication_type: PublicationType.find_by!(name: attrs[:publication_type_name]),
    book_binding: BookBinding.find_by!(name: attrs[:book_binding_name]),
    paper_type: PaperType.find_by!(name: attrs[:paper_type_name]),
    collection: Collection.find_by(name: attrs[:collection_name]),
    story_count: attrs[:story_count],
    link_guia_dos_quadrinhos: attrs[:link_guia_dos_quadrinhos],
    issue_number: attrs[:issue_number],
    issue_title: attrs[:issue_title],
  )

  comic.authors =
    attrs[:author_names].map { |name| Author.find_by!(name: name) }

  comic.characters =
    Array(attrs[:character_names]).map { |name| Character.find_by!(name: name) }

  comic.save!

  Array(attrs[:read_dates]).each do |date|
    comic.readings.find_or_create_by!(read_at: date)
  end

  next if comic.cover_image.attached?

  filename = if comic.collection.present?
    "#{comic.title} n° #{comic.issue_number}.jpg"
  else
    "#{comic.title}.jpg"
  end

  path = Rails.root.join("db", "seeds", "covers", filename)

  next unless File.exist?(path)

  comic.cover_image.attach(
    io: File.open(path),
    filename: filename,
    content_type: "image/jpeg",
  )
end

User.find_or_create_by!(email: "admin@admin.com") do |user|
  user.username = "admin"
  user.password = "123456"
  user.password_confirmation = "123456"
  user.admin = true
end

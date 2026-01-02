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

publication_types.each do |name|
  PublicationType.find_or_create_by!(name: name)
end

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

comics = [
  { title: "Justiceiro - Frank contra o mundo", page_count: 124, published_year: 2019, author_name: "Matthew Rosenberg", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", read_date: "2025-10-08" },
  { title: "Justiceiro - Guerra na Bagália", page_count: 140, published_year: 2020, author_name: "Matthew Rosenberg", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", read_date: "2025-10-08" },
  { title: "Justiceiro - Rua a rua, quadra a quadra", page_count: 124, published_year: 2020, author_name: "Matthew Rosenberg", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", read_date: "2025-10-09" },
  { title: "Justiceiro - Equipe de extermínio", page_count: 132, published_year: 2020, author_name: "Gerry Duggan", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", read_date: "2025-10-09" },
  { title: "Justiceiro - Ano Um", page_count: 108, published_year: 2019, author_name: "Dan Abnett", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-10-10" },
  { title: "Justiceiro - No princípio", page_count: 388, published_year: 2018, author_name: "Garth Ennis", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-10-14" },
  { title: "Justiceiro - Mãe Rússia", page_count: 428, published_year: 2018, author_name: "Garth Ennis", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-10-18" },
  { title: "Justiceiro - Barracuda", page_count: 448, published_year: 2019, author_name: "Garth Ennis", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-10-23" },
  { title: "Justiceiro - Paladinos Marvel 4", page_count: 164, published_year: 2017, author_name: "Steven Grant", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "Offset", read_date: "2025-10-24" },
  { title: "Justiceiro - Mike Baron & Klaus Janson", page_count: 180, published_year: 2024, author_name: "Mike Baron", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-10-25" },
  { title: "Justiceiro - O primeiro sacramento de Frank", page_count: 148, published_year: 2023, author_name: "Jason Aaron", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", read_date: "2025-10-26" },
  { title: "Justiceiro - A guerra dos deuses da guerra", page_count: 140, published_year: 2023, author_name: "Jason Aaron", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", read_date: "2025-10-26" },
  { title: "Justiceiro - O rei dos assasinos", page_count: 140, published_year: 2023, author_name: "Jason Aaron", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", read_date: "2025-10-27" },
  { title: "Justiceiro - O fim do reinado", page_count: 108, published_year: 2024, author_name: "Jason Aaron", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", read_date: "2025-10-27" },
  { title: "Justiceiro - O próximo tiro", page_count: 116, published_year: 2025, author_name: "David Pepose", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", read_date: "2025-10-27" },
  { title: "Justiceiro - Wolverine e Motoqueiro Fantasma: corações sombrios", page_count: 116, published_year: 2023, author_name: "Howard Mackie", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-10-28" },
  { title: "Justiceiro - Por Greg Rucka Vol. 1", page_count: 284, published_year: 2024, author_name: "Greg Rucka", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-10-30" },
  { title: "Justiceiro - Por Greg Rucka Vol. 2", page_count: 268, published_year: 2025, author_name: "Greg Rucka", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-10-31" },
  { title: "Justiceiro - Valley Forge", page_count: 534, published_year: 2019, author_name: "Garth Ennis", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-11-05" },
  { title: "Justiceiro - O pelotão", page_count: 140, published_year: 2020, author_name: "Garth Ennis", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-11-06" },
  { title: "Justiceiro - O soviético", page_count: 140, published_year: 2020, author_name: "Garth Ennis", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-11-07" },
  { title: "Justiceiro - Zona de guerra", page_count: 164, published_year: 2021, author_name: "Chuck Dixon", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-11-10" },
  { title: "Sara", page_count: 152, published_year: 2021, author_name: "Garth Ennis", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-11-10" },
  { title: "Thor Vikings", page_count: 132, published_year: 2024, author_name: "Garth Ennis", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-11-11" },
  { title: "Superman - Entre A Foice e O Martelo", page_count: 172, published_year: 2017, author_name: "Mark Millar", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-11-13" },
  { title: "Motoqueiro Fantasma - Estrada Para A Danação", page_count: 148, published_year: 2012, author_name: "Garth Ennis", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", read_date: "2025-11-14" },
  { title: "Um Passeio No Inferno n° 1", page_count: 112, published_year: 2022, author_name: "Garth Ennis", publisher_name: "Alta Geek", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-11-18" },
  { title: "Um Passeio No Inferno n° 2", page_count: 164, published_year: 2023, author_name: "Garth Ennis", publisher_name: "Alta Geek", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", read_date: "2025-11-18" },
  { title: "V de Vingança", page_count: 308, published_year: 2012, author_name: "Alan Moore", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", read_date: "2025-12-16" },
  { title: "Procurado n° 1", page_count: 50, published_year: 2005, author_name: "Mark Millar", publisher_name: "Mythos", publication_type_name: "HQ", book_binding_name: "Canoa", paper_type_name: "LWC", read_date: "2025-12-17" },
  { title: "Procurado n° 2", page_count: 50, published_year: 2005, author_name: "Mark Millar", publisher_name: "Mythos", publication_type_name: "HQ", book_binding_name: "Canoa", paper_type_name: "LWC", read_date: "2025-12-17" },
  { title: "Procurado n° 3", page_count: 50, published_year: 2005, author_name: "Mark Millar", publisher_name: "Mythos", publication_type_name: "HQ", book_binding_name: "Canoa", paper_type_name: "LWC", read_date: "2025-12-17" },
  { title: "Justiceiro - Preto e branco", page_count: 132, published_year: 2015, author_name: "Nathan Edmondson", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", read_date: "2025-12-25" },
  { title: "Justiceiro - Atravessando a fronteira", page_count: 148, published_year: 2016, author_name: "Nathan Edmondson", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", read_date: "2025-12-25" },
  { title: "Justiceiro - Ultimos dias", page_count: 172, published_year: 2016, author_name: "Nathan Edmondson", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", read_date: "2026-01-03" },
  { title: "Justiceiro & Capitão América - Sangue e Glória n° 1", page_count: 52, published_year: 1993, author_name: "Dan D. G. Chichester", publisher_name: "Abril", publication_type_name: "HQ", book_binding_name: "Canoa", paper_type_name: "LWC", read_date: "2026-01-03" },
  { title: "Justiceiro & Capitão América - Sangue e Glória n° 2", page_count: 52, published_year: 1994, author_name: "Dan D. G. Chichester", publisher_name: "Abril", publication_type_name: "HQ", book_binding_name: "Canoa", paper_type_name: "LWC", read_date: "2026-01-03" },
  { title: "Justiceiro & Capitão América - Sangue e Glória n° 3", page_count: 52, published_year: 1994, author_name: "Dan D. G. Chichester", publisher_name: "Abril", publication_type_name: "HQ", book_binding_name: "Canoa", paper_type_name: "LWC", read_date: "2026-01-03" },
  { title: "Paladinos Marvel n° 1", page_count: 100, published_year: 2002, author_name: "Garth Ennis", publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Canoa", paper_type_name: "LWC", read_date: "2026-01-04" },
]

comics.each do |comic_attrs|
  author = Author.find_by!(name: comic_attrs.delete(:author_name))
  publisher = Publisher.find_by!(name: comic_attrs.delete(:publisher_name))
  publication_type = PublicationType.find_by!(name: comic_attrs.delete(:publication_type_name))
  book_binding = BookBinding.find_by!(name: comic_attrs.delete(:book_binding_name))
  paper_type = PaperType.find_by!(name: comic_attrs.delete(:paper_type_name))

  Comic.find_or_create_by!(
    title: comic_attrs[:title],
    page_count: comic_attrs[:page_count],
    published_year: comic_attrs[:published_year],
    author: author,
    publisher: publisher,
    publication_type: publication_type,
    book_binding: book_binding,
    paper_type: paper_type,
  ) do |comic|
    comic.read_date = comic_attrs[:read_date]
  end
end

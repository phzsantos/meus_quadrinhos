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
  "Andy Lanning",
  "Mark Waid",
  "Torunn Grønbekk",
  "Gerry Conway",
  "Margaret Clark",
  "Grant Morrison",
  "Dan Jurgens",
  "Paul Jenkins",
  "Kevin Maurer",
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

collections = [
  "Marvel Deluxe: Justiceiro",
  "Justiceiro 2ª Série",
  "Justiceiro 3ª Série",
  "Justiceiro 4ª Série",
  "Justiceiro Por Greg Rucka",
  "Justiceiro & Capitão América - Sangue e Glória",
  "Paladinos Marvel",
  "Procurado",
  "Um Passeio No Inferno",
]

collections.each do |name|
  Collection.find_or_create_by!(name: name)
end

comics = [
  { title: "Justiceiro 3ª Série - n° 1", page_count: 124, collection_name: "Justiceiro 3ª Série", published_year: 2019, author_names: ["Matthew Rosenberg"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-3-serie-n-1/ju011300/148166", story_count: 5, read_dates: ["2025-10-08"] },
  { title: "Justiceiro 3ª Série - n° 2", page_count: 140, collection_name: "Justiceiro 3ª Série", published_year: 2020, author_names: ["Matthew Rosenberg"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-3-serie-n-2/ju011300/151441", story_count: 6, read_dates: ["2025-10-08"] },
  { title: "Justiceiro 3ª Série - n° 3", page_count: 124, collection_name: "Justiceiro 3ª Série", published_year: 2020, author_names: ["Matthew Rosenberg"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-3-serie-n-3/ju011300/153972", story_count: 5, read_dates: ["2025-10-09"] },
  { title: "Justiceiro 3ª Série - n° 4", page_count: 132, collection_name: "Justiceiro 3ª Série", published_year: 2020, author_names: ["Gerry Duggan"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-3-serie-n-4/ju011300/155922", story_count: 6, read_dates: ["2025-10-09"] },
  { title: "Justiceiro - Ano Um", page_count: 108, published_year: 2019, author_names: ["Dan Abnett", "Andy Lanning"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-ano-um/ju011116/145531", story_count: 4, read_dates: ["2025-10-10"] },
  { title: "Marvel Deluxe: Justiceiro n° 1", page_count: 388, collection_name: "Marvel Deluxe: Justiceiro", published_year: 2018, author_names: ["Garth Ennis"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/marvel-deluxe-justiceiro-n-1/ma011157/139978", story_count: 16, read_dates: ["2025-10-14"] },
  { title: "Marvel Deluxe: Justiceiro n° 2", page_count: 428, collection_name: "Marvel Deluxe: Justiceiro", published_year: 2018, author_names: ["Garth Ennis"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/marvel-deluxe-justiceiro-n-2/ma011157/141682", story_count: 18, read_dates: ["2025-10-18"] },
  { title: "Marvel Deluxe: Justiceiro n° 3", page_count: 448, collection_name: "Marvel Deluxe: Justiceiro", published_year: 2019, author_names: ["Garth Ennis"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/marvel-deluxe-justiceiro-n-3/ma011157/143655", story_count: 19, read_dates: ["2025-10-23"] },
  { title: "Coleção Histórica: Paladinos Marvel n° 4", page_count: 164, published_year: 2017, author_names: ["Gerry Conway", "Steven Grant"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "Offset", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/colecao-historica-paladinos-marvel-n-4/co011151/133658", story_count: 6, read_dates: ["2025-10-24"] },
  { title: "Justiceiro Por Mike Baron & Klaus Janson", page_count: 180, published_year: 2024, author_names: ["Mike Baron"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-por-mike-baron-e-klaus-janson/ju011127/176510", story_count: 7, read_dates: ["2025-10-25"] },
  { title: "Justiceiro 4ª Série - n° 1", page_count: 148, collection_name: "Justiceiro 4ª Série", published_year: 2023, author_names: ["Jason Aaron", "Torunn Grønbekk"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-4-serie-n-1/ju011400/170239", story_count: 4, read_dates: ["2025-10-26"] },
  { title: "Justiceiro 4ª Série - n° 2", page_count: 140, collection_name: "Justiceiro 4ª Série", published_year: 2023, author_names: ["Jason Aaron", "Torunn Grønbekk"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-4-serie-n-2/ju011400/174006", story_count: 4, read_dates: ["2025-10-26"] },
  { title: "Justiceiro 4ª Série - n° 3", page_count: 140, collection_name: "Justiceiro 4ª Série", published_year: 2023, author_names: ["Jason Aaron", "Torunn Grønbekk"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-4-serie-n-3/ju011400/174995", story_count: 4, read_dates: ["2025-10-27"] },
  { title: "Justiceiro 4ª Série - n° 4", page_count: 108, collection_name: "Justiceiro 4ª Série", published_year: 2024, author_names: ["Jason Aaron"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-4-serie-n-4/ju011400/177006", story_count: 3, read_dates: ["2025-10-27"] },
  { title: "Justiceiro: O Próximo Tiro", page_count: 116, published_year: 2025, author_names: ["David Pepose"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-o-proximo-tiro/ju011500/182029", story_count: 4, read_dates: ["2025-10-27"] },
  { title: "Motoqueiro Fantasma, Wolverine, Justiceiro: Corações Sombrios", page_count: 116, published_year: 2023, author_names: ["Howard Mackie"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/motoqueiro-fantasma-wolverine-justiceiro-coracoes-sombrios/mo011151/175613", story_count: 2, read_dates: ["2025-10-28"] },
  { title: "Justiceiro Por Greg Rucka n° 1", page_count: 284, collection_name: "Justiceiro Por Greg Rucka", published_year: 2024, author_names: ["Greg Rucka", "Mark Waid"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-por-greg-rucka-n-1/ju011128/178028", story_count: 13, read_dates: ["2025-10-30"] },
  { title: "Justiceiro Por Greg Rucka n° 2", page_count: 268, collection_name: "Justiceiro Por Greg Rucka", published_year: 2025, author_names: ["Greg Rucka"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-por-greg-rucka-n-2/ju011128/184511", story_count: 12, read_dates: ["2025-10-31"] },
  { title: "Marvel Deluxe: Justiceiro n° 4", page_count: 534, collection_name: "Marvel Deluxe: Justiceiro", published_year: 2019, author_names: ["Garth Ennis"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/marvel-deluxe-justiceiro-n-4/ma011157/149089", story_count: 19, read_dates: ["2025-11-05"] },
  { title: "Justiceiro - O Pelotão", page_count: 140, published_year: 2020, author_names: ["Garth Ennis"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-o-pelotao/ju011118/151647", story_count: 6, read_dates: ["2025-11-06"] },
  { title: "Justiceiro - O Soviético", page_count: 140, published_year: 2020, author_names: ["Garth Ennis"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-o-sovietico/ju011121/156599", story_count: 6, read_dates: ["2025-11-07"] },
  { title: "Justiceiro: Zona de Guerra", page_count: 164, published_year: 2021, author_names: ["Chuck Dixon"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-zona-de-guerra/ju011122/157946", story_count: 6, read_dates: ["2025-11-10"] },
  { title: "Sara", page_count: 152, published_year: 2021, author_names: ["Garth Ennis"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/sara/sa011128/158907", story_count: 1, read_dates: ["2025-11-10"] },
  { title: "Thor: Vikings (2ª Edição)", page_count: 132, published_year: 2024, author_names: ["Garth Ennis"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/thor-vikings-(2-edicao)/th011201/180577", story_count: 5, read_dates: ["2025-11-11"] },
  { title: "Superman - Entre A Foice e O Martelo (Capa Dura)", page_count: 172, published_year: 2017, author_names: ["Mark Millar"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/superman-entre-a-foice-e-o-martelo-(capa-dura)/su011134/133681", story_count: 3, read_dates: ["2025-11-13"] },
  { title: "Motoqueiro Fantasma - Estrada Para A Danação", page_count: 148, published_year: 2012, author_names: ["Garth Ennis"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/motoqueiro-fantasma-estrada-para-a-danacao/mo011106/96447", story_count: 6, read_dates: ["2025-11-14"] },
  { title: "Um Passeio No Inferno n° 1", page_count: 112, collection_name: "Um Passeio No Inferno", published_year: 2022, author_names: ["Garth Ennis"], publisher_name: "Alta Geek", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/um-passeio-no-inferno-n-1/um237910/169241", story_count: 5, read_dates: ["2025-11-18"] },
  { title: "Um Passeio No Inferno n° 2", page_count: 164, collection_name: "Um Passeio No Inferno", published_year: 2023, author_names: ["Garth Ennis"], publisher_name: "Alta Geek", publication_type_name: "HQ", book_binding_name: "Capa dura", paper_type_name: "Couché", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/um-passeio-no-inferno-n-2/um237910/174468", story_count: 7, read_dates: ["2025-11-18"] },
  { title: "V de Vingança (2ª Edição)", page_count: 308, published_year: 2012, author_names: ["Alan Moore"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/v-de-vinganca-(2-edicao)/v%20011200/98159", story_count: 10, read_dates: ["2025-12-16"] },
  { title: "Procurado n° 1", page_count: 50, collection_name: "Procurado", published_year: 2005, author_names: ["Mark Millar"], publisher_name: "Mythos", publication_type_name: "HQ", book_binding_name: "Canoa", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/procurado-n-1/wa062100/27865", story_count: 2, read_dates: ["2025-12-17"] },
  { title: "Procurado n° 2", page_count: 50, collection_name: "Procurado", published_year: 2005, author_names: ["Mark Millar"], publisher_name: "Mythos", publication_type_name: "HQ", book_binding_name: "Canoa", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/procurado-n-2/wa062100/27866", story_count: 2, read_dates: ["2025-12-17"] },
  { title: "Procurado n° 3", page_count: 50, collection_name: "Procurado", published_year: 2005, author_names: ["Mark Millar"], publisher_name: "Mythos", publication_type_name: "HQ", book_binding_name: "Canoa", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/procurado-n-3/wa062100/27867", story_count: 2, read_dates: ["2025-12-17"] },
  { title: "Justiceiro 2ª Série - n° 1", page_count: 132, collection_name: "Justiceiro 2ª Série", published_year: 2015, author_names: ["Nathan Edmondson"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-2-serie-n-1/ju011200/120191", story_count: 6, read_dates: ["2025-12-25"] },
  { title: "Justiceiro 2ª Série - n° 2", page_count: 148, collection_name: "Justiceiro 2ª Série", published_year: 2016, author_names: ["Nathan Edmondson", "Kevin Maurer"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-2-serie-n-2/ju011200/124132", story_count: 7, read_dates: ["2025-12-25"] },
  { title: "Justiceiro 2ª Série - n° 3", page_count: 172, collection_name: "Justiceiro 2ª Série", published_year: 2016, author_names: ["Nathan Edmondson"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Capa cartão", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-2-serie-n-3/ju011200/125079", story_count: 8, read_dates: ["2026-01-03"] },
  { title: "Justiceiro & Capitão América - Sangue e Glória n° 1", page_count: 52, collection_name: "Justiceiro & Capitão América - Sangue e Glória", published_year: 1993, author_names: ["Dan D. G. Chichester", "Margaret Clark"], publisher_name: "Abril", publication_type_name: "HQ", book_binding_name: "Canoa", paper_type_name: "Jornal", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-e-capitao-america-sangue-e-gloria-n-1/jca0301/6932", story_count: 1, read_dates: ["2026-01-03"] },
  { title: "Justiceiro & Capitão América - Sangue e Glória n° 2", page_count: 52, collection_name: "Justiceiro & Capitão América - Sangue e Glória", published_year: 1994, author_names: ["Dan D. G. Chichester", "Margaret Clark"], publisher_name: "Abril", publication_type_name: "HQ", book_binding_name: "Canoa", paper_type_name: "Jornal", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-e-capitao-america-sangue-e-gloria-n-2/jca0301/6933", story_count: 1, read_dates: ["2026-01-03"] },
  { title: "Justiceiro & Capitão América - Sangue e Glória n° 3", page_count: 52, collection_name: "Justiceiro & Capitão América - Sangue e Glória", published_year: 1994, author_names: ["Dan D. G. Chichester", "Margaret Clark"], publisher_name: "Abril", publication_type_name: "HQ", book_binding_name: "Canoa", paper_type_name: "Jornal", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/justiceiro-e-capitao-america-sangue-e-gloria-n-3/jca0301/6934", story_count: 1, read_dates: ["2026-01-03"] },
  { title: "Paladinos Marvel n° 1", page_count: 100, collection_name: "Paladinos Marvel", published_year: 2002, author_names: ["Garth Ennis", "Grant Morrison", "Dan Jurgens", "Paul Jenkins"], publisher_name: "Panini", publication_type_name: "HQ", book_binding_name: "Canoa", paper_type_name: "LWC", link_guia_dos_quadrinhos: "http://www.guiadosquadrinhos.com/edicao/paladinos-marvel-n-1/pa011100/26963", story_count: 4, read_dates: ["2026-01-04"] },
]

comics.each do |attrs|
  authors = attrs.delete(:author_names).map do |name|
    Author.find_by!(name: name)
  end

  collection = Collection.find_by!(name: attrs.delete(:collection_name)) if attrs[:collection_name]
  publisher = Publisher.find_by!(name: attrs.delete(:publisher_name))
  publication_type = PublicationType.find_by!(name: attrs.delete(:publication_type_name))
  book_binding = BookBinding.find_by!(name: attrs.delete(:book_binding_name))
  paper_type = PaperType.find_by!(name: attrs.delete(:paper_type_name))

  read_dates = attrs.delete(:read_dates) || []

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
  comic.save!

  if read_dates.present?
    read_dates.each do |date|
      comic.readings.find_or_create_by!(read_at: date)
    end
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

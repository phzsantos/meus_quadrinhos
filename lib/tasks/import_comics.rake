# frozen_string_literal: true

namespace :import do
  desc "Import comics from json file"
  task comics: :environment do
    show_spinner("Importing comics...") { import_comics }
  end

  def import_comics
    admin = User.find_by!(email: "admin@admin.com")
    comics = JSON.parse(File.read(Rails.root.join("db/seeds/comics.json")), symbolize_names: true)

    comics.each do |attrs|
      comic = Comic.find_or_initialize_by(
        title: attrs[:title],
        issue_number: attrs[:issue_number],
        published_year: attrs[:published_year],
      )

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
        comic.readings.find_or_create_by!(user: admin, read_at: date)
      end

      admin.user_comics.find_or_create_by!(comic: comic) if attrs.fetch(:owned, true)

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
  end
end

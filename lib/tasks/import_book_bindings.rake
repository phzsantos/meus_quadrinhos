# frozen_string_literal: true

namespace :import do
  desc "Import book bindings from json file"
  task book_bindings: :environment do
    show_spinner("Importing book bindings...") { import_book_bindings }
  end

  def import_book_bindings
    book_bindings = JSON.parse(File.read(Rails.root.join("db/seeds/book_bindings.json")))
    book_bindings.each do |name|
      BookBinding.find_or_create_by!(name:)
    end
  end
end

# frozen_string_literal: true

namespace :export do
  desc "Export book bindings to json file"
  task book_bindings: :environment do
    show_spinner("Exporting book bindings...") do
      export_via_controller(BookBindingsController, "book_bindings.json")
    end
  end
end

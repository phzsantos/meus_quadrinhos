# frozen_string_literal: true

namespace :export do
  desc "Export comics to json file"
  task comics: :environment do
    show_spinner("Exporting comics...") do
      export_via_controller(ComicsController, "comics.json")
    end
  end
end

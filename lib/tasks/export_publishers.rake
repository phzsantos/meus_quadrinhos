# frozen_string_literal: true

namespace :export do
  desc "Export publishers to json file"
  task publishers: :environment do
    show_spinner("Exporting publishers...") do
      export_via_controller(PublishersController, "publishers.json")
    end
  end
end

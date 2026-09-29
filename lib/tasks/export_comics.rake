# frozen_string_literal: true

namespace :export do
  desc "Export comics to json file"
  task comics: :environment do
    show_spinner("Exporting comics...") do
      admin = User.find_by!(email: "admin@admin.com")
      export_via_controller(ComicsController, "comics.json", user: admin)
    end
  end
end

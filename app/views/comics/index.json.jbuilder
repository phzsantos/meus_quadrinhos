# frozen_string_literal: true

json.array!(@comics, partial: "comics/comic", as: :comic)

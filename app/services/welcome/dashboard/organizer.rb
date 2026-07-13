# frozen_string_literal: true

module Welcome
  module Dashboard
    class Organizer
      include Interactor::Organizer

      organize(
        ComicsReadByYear,
        PagesReadByYear,
        ComicsReadByMonth,
        PagesReadByMonth,
        StoriesReadByMonth,
        LatestReadings,
        GeneralStatistics,
      )
    end
  end
end

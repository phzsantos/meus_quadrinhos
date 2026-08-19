# frozen_string_literal: true

module Welcome
  module Dashboard
    class Organizer
      include Interactor::Organizer

      organize(
        ComicsReadByYear,
        PagesReadByYear,
        ComicsReadByPublisher,
        ComicsReadByCharacter,
        ComicsReadByMonth,
        PagesReadByMonth,
        StoriesReadByMonth,
        ComicsReadByDayComparison,
        LatestReadings,
        GeneralStatistics,
      )
    end
  end
end

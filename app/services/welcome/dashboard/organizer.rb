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
        ComicsReadByAuthor,
        ComicsReadByPaperType,
        ComicsReadByBookBinding,
        ComicsReadByPublicationType,
        ComicsReadByMonth,
        PagesReadByMonth,
        StoriesReadByMonth,
        ComicsReadByDayComparison,
        LatestReadings,
        GeneralStatistics,
        ReadingRecords,
      )
    end
  end
end

# frozen_string_literal: true

module Welcome
  module Dashboard
    class CollectionStatistics
      include Interactor

      def call
        owned_comics = context.user.owned_comics
        read_comic_ids = context.user.readings.where.not(read_at: nil).select(:comic_id)

        context.total_collection_comics = owned_comics.count
        context.total_unread_comics = owned_comics.where.not(id: read_comic_ids).count
        context.total_collection_pages = owned_comics.sum(:page_count)
        context.total_collection_stories = owned_comics.sum(:story_count)
      end
    end
  end
end

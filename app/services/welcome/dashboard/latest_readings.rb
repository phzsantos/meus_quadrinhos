# frozen_string_literal: true

module Welcome
  module Dashboard
    class LatestReadings
      include Interactor
      include UserScopedReadings

      def call
        context.latest_readings = readings_scope
          .includes(:comic)
          .where.not(read_at: nil)
          .order(read_at: :desc, created_at: :desc)
          .limit(6)
      end
    end
  end
end

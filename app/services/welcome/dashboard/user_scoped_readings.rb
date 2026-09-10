# frozen_string_literal: true

module Welcome
  module Dashboard
    module UserScopedReadings
      private

      def readings_scope
        context.user.readings
      end
    end
  end
end

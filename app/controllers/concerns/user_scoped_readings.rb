# frozen_string_literal: true

module UserScopedReadings
  extend ActiveSupport::Concern

  private

  def assign_current_user_to_readings(comic)
    comic.readings.each do |reading|
      reading.user_id ||= current_user.id
    end
  end

  def filter_readings_attributes!(permitted, comic: @comic)
    attrs = permitted[:readings_attributes]
    return if attrs.blank?

    allowed_ids = if comic&.persisted?
      current_user.readings.where(comic_id: comic.id).pluck(:id).map(&:to_s)
    else
      []
    end

    keep = lambda do |reading_attrs|
      return false if reading_attrs.blank?

      reading_attrs[:id].blank? || allowed_ids.include?(reading_attrs[:id].to_s)
    end

    permitted[:readings_attributes] =
      if attrs.respond_to?(:each_pair)
        attrs.select { |_key, reading_attrs| keep.call(reading_attrs) }
      else
        Array(attrs).select { |reading_attrs| keep.call(reading_attrs) }
      end
  end
end

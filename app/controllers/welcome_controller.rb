# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    context = Welcome::Dashboard::Organizer.call

    @read_comics_years = context.read_comics_years
    @read_comics_count_by_year = context.read_comics_count_by_year

    @pages_read_years = context.pages_read_years
    @pages_read_count_by_year = context.pages_read_count_by_year

    load_comics_read_by_month
    load_pages_read_by_month
    load_latest_readings
    load_general_satistics
  end

  private

  def load_comics_read_by_month
    grouped_by_month = Reading
      .where.not(read_at: nil)
      .group_by { |r| r.read_at.beginning_of_month }

    @read_comics_months = grouped_by_month.keys.sort
    @read_comics_count_by_month =
      @read_comics_months.map { |month| grouped_by_month[month].count }
  end

  def load_pages_read_by_month
    grouped_by_month = Reading
      .includes(:comic)
      .where.not(read_at: nil)
      .group_by { |r| r.read_at.beginning_of_month }

    @pages_read_months = grouped_by_month.keys.sort
    @pages_read_count_by_month =
      @pages_read_months.map do |month|
        grouped_by_month[month].sum { |r| r.comic.page_count.to_i }
      end
  end

  def load_latest_readings
    @latest_readings = Reading
      .includes(:comic)
      .where.not(read_at: nil)
      .order(read_at: :desc, created_at: :desc)
      .limit(6)
  end

  def load_general_satistics
    @total_comics_read = Reading.where.not(read_at: nil).count

    @total_pages_read = Reading
      .includes(:comic)
      .where.not(read_at: nil)
      .sum { |r| r.comic.page_count.to_i }

    @total_story_count = Reading
      .includes(:comic)
      .where.not(read_at: nil)
      .sum { |r| r.comic.story_count.to_i }

    @comics_read_this_month = Reading
      .where.not(read_at: nil)
      .where(read_at: Time.current.beginning_of_month..Time.current.end_of_month)
      .count
  end
end

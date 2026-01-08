# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    load_comics_read_by_year
    load_pages_read_by_year
    load_comics_read_by_month
    load_pages_read_by_month
    load_latest_readings
  end

  private

  def load_comics_read_by_year
    grouped_by_year = Reading
      .where.not(read_at: nil)
      .group_by { |r| r.read_at.year }

    @read_comics_years = grouped_by_year.keys.sort
    @read_comics_count_by_year =
      @read_comics_years.map { |year| grouped_by_year[year].count }
  end

  def load_pages_read_by_year
    grouped_by_year = Reading
      .includes(:comic)
      .where.not(read_at: nil)
      .group_by { |r| r.read_at.year }

    @pages_read_years = grouped_by_year.keys.sort
    @pages_read_count_by_year =
      @pages_read_years.map do |year|
        grouped_by_year[year].sum { |r| r.comic.page_count.to_i }
      end
  end

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
end

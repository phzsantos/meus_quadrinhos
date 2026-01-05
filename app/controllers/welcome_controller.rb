# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    load_comics_read_by_year
    load_pages_read_by_year
    load_comics_read_by_month
    load_pages_read_by_month
  end

  private

  def load_comics_read_by_year
    grouped_by_year = Comic
      .where.not(read_date: nil)
      .select(:read_date)
      .group_by { |comic| comic.read_date.year }

    @read_comics_years = grouped_by_year.keys.sort
    @read_comics_count_by_year =
      @read_comics_years.map { |year| grouped_by_year[year].count }
  end

  def load_pages_read_by_year
    grouped_by_year = Comic
      .where.not(read_date: nil)
      .select(:read_date, :page_count)
      .group_by { |comic| comic.read_date.year }

    @pages_read_years = grouped_by_year.keys.sort
    @pages_read_count_by_year =
      @pages_read_years.map do |year|
        grouped_by_year[year].sum { |comic| comic.page_count || 0 }
      end
  end

  def load_comics_read_by_month
    grouped_by_month = Comic
      .where.not(read_date: nil)
      .select(:read_date)
      .group_by { |comic| comic.read_date.beginning_of_month }

    @read_comics_months = grouped_by_month.keys.sort
    @read_comics_count_by_month =
      @read_comics_months.map { |month| grouped_by_month[month].count }
  end

  def load_pages_read_by_month
    grouped_by_month = Comic
      .where.not(read_date: nil)
      .select(:read_date, :page_count)
      .group_by { |comic| comic.read_date.beginning_of_month }

    @pages_read_months = grouped_by_month.keys.sort
    @pages_read_count_by_month =
      @pages_read_months.map do |month|
        grouped_by_month[month].sum { |comic| comic.page_count || 0 }
      end
  end
end

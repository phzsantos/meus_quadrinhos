# frozen_string_literal: true

class WelcomeController < ApplicationController
  before_action :authenticate_user!

  def index
    context = Welcome::Dashboard::Organizer.call(
      user: current_user,
      start_date: 11.months.ago.beginning_of_month,
      end_date: Time.current.end_of_month,
    )

    load_dashboard_data(context)
  end

  private

  def load_dashboard_data(context)
    @read_comics_years = context.read_comics_years
    @read_comics_count_by_year = context.read_comics_count_by_year

    @pages_read_years = context.pages_read_years
    @pages_read_count_by_year = context.pages_read_count_by_year

    @read_comics_publishers = context.read_comics_publishers
    @read_comics_count_by_publisher = context.read_comics_count_by_publisher

    @read_comics_characters = context.read_comics_characters
    @read_comics_count_by_character = context.read_comics_count_by_character

    @read_comics_authors = context.read_comics_authors
    @read_comics_count_by_author = context.read_comics_count_by_author

    @read_comics_paper_types = context.read_comics_paper_types
    @read_comics_count_by_paper_type = context.read_comics_count_by_paper_type

    @read_comics_book_bindings = context.read_comics_book_bindings
    @read_comics_count_by_book_binding = context.read_comics_count_by_book_binding

    @read_comics_publication_types = context.read_comics_publication_types
    @read_comics_count_by_publication_type = context.read_comics_count_by_publication_type

    @read_comics_months = context.read_comics_months
    @read_comics_count_by_month = context.read_comics_count_by_month

    @pages_read_months = context.pages_read_months
    @pages_read_count_by_month = context.pages_read_count_by_month

    @read_stories_months = context.read_stories_months
    @read_stories_count_by_month = context.read_stories_count_by_month

    @read_comics_comparison_days = context.read_comics_comparison_days
    @read_comics_count_by_day_current = context.read_comics_count_by_day_current
    @read_comics_count_by_day_previous = context.read_comics_count_by_day_previous
    @read_comics_comparison_current_label = context.read_comics_comparison_current_label
    @read_comics_comparison_previous_label = context.read_comics_comparison_previous_label

    @latest_readings = context.latest_readings

    @total_comics_read = context.total_comics_read
    @total_story_count = context.total_story_count
    @total_pages_read = context.total_pages_read
    @comics_read_this_month = context.comics_read_this_month
    @current_reading_streak_days = context.current_reading_streak_days

    @total_collection_comics = context.total_collection_comics
    @total_unread_comics = context.total_unread_comics
    @total_collection_pages = context.total_collection_pages
    @total_collection_stories = context.total_collection_stories

    @best_month = context.best_month
    @best_month_comics_count = context.best_month_comics_count
    @best_stories_month = context.best_stories_month
    @best_month_stories_count = context.best_month_stories_count
    @best_pages_month = context.best_pages_month
    @best_month_pages_count = context.best_month_pages_count
    @longest_reading_streak_days = context.longest_reading_streak_days
    @longest_reading_streak_start = context.longest_reading_streak_start
    @longest_reading_streak_end = context.longest_reading_streak_end
  end
end

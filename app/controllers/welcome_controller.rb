# frozen_string_literal: true

class WelcomeController < ApplicationController
  before_action :authenticate_user!

  def index
    context = Welcome::Dashboard::Organizer.call

    load_dashboard_data(context)
  end

  private

  def load_dashboard_data(context)
    @read_comics_years = context.read_comics_years
    @read_comics_count_by_year = context.read_comics_count_by_year

    @pages_read_years = context.pages_read_years
    @pages_read_count_by_year = context.pages_read_count_by_year

    @read_comics_months = context.read_comics_months
    @read_comics_count_by_month = context.read_comics_count_by_month

    @pages_read_months = context.pages_read_months
    @pages_read_count_by_month = context.pages_read_count_by_month

    @latest_readings = context.latest_readings

    @total_comics_read = context.total_comics_read
    @total_story_count = context.total_story_count
    @total_pages_read = context.total_pages_read
    @comics_read_this_month = context.comics_read_this_month
  end
end

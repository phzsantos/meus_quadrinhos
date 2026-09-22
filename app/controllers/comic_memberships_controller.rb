# frozen_string_literal: true

class ComicMembershipsController < ApplicationController
  include UserScopedReadings

  before_action :authenticate_user!
  before_action :set_comic

  def edit
    prepare_form
  end

  def update
    saved = false

    ActiveRecord::Base.transaction do
      @comic.assign_attributes(readings_params)
      assign_current_user_to_readings(@comic)
      saved = @comic.save
      raise ActiveRecord::Rollback unless saved
    end

    if saved
      redirect_to(@comic, notice: "Leituras atualizadas.", status: :see_other)
    else
      prepare_form
      render(:edit, status: :unprocessable_content)
    end
  end

  private

  def set_comic
    @comic = Comic.friendly.find(params[:comic_id])
  end

  def prepare_form
    @existing_readings = @comic.readings_for(current_user).order(:read_at)
    @new_reading = @comic.readings.build(user: current_user)
  end

  def readings_params
    permitted = params.fetch(:comic, {}).permit(readings_attributes: [:id, :read_at, :_destroy])
    filter_readings_attributes!(permitted)
    permitted
  end
end

# frozen_string_literal: true

module ApplicationHelper
  def nav_link_to(name, path, controllers:, **options)
    base_classes = "flex justify-center items-center px-3 sm:px-6 py-2 sm:py-3 transition"
    active_classes = "bg-black text-bada"
    inactive_classes = "hover:bg-black/20"

    is_active = controllers.include?(controller_name)
    classes = is_active ? active_classes : inactive_classes

    link_to(name, path, class: "#{base_classes} #{classes}", **options)
  end

  def page_title
    base = "Meus Quadrinhos"
    record = record_page_label
    return "#{record} | #{base}" if record.present?

    section = t("controllers.#{controller_name}")
    [new_page_label, section, base].compact.join(" | ")
  end

  def visible_comics_count(resource)
    resource.comics.visible_to(current_user).count
  end

  private

  def record_page_label
    return if ["show", "edit", "update"].exclude?(action_name)

    current_record_label
  end

  def new_page_label
    "Novo" if ["new", "create"].include?(action_name) && !authentication_page?
  end

  def authentication_page?
    ["sessions", "registrations", "passwords"].include?(controller_name)
  end

  def current_record_label
    resource = current_record
    return if resource.blank?

    resource.try(:display_title).presence ||
      resource.try(:name).presence ||
      resource.try(:title).presence
  end

  def current_record
    name = controller_name == "comic_memberships" ? "comic" : controller_name.singularize
    instance_variable_get(:"@#{name}")
  end
end

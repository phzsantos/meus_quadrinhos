# frozen_string_literal: true

module ApplicationHelper
  def nav_link_to(name, path, controllers:, **options)
    base_classes = "flex justify-center items-center px-6 py-3 transition"
    active_classes = "bg-black text-bada"
    inactive_classes = "hover:bg-black/20"

    is_active = controllers.include?(controller_name)
    classes = is_active ? active_classes : inactive_classes

    link_to(name, path, class: "#{base_classes} #{classes}", **options)
  end

  def page_title
    base = "MeusQuadrinhos"

    # title = "controllers.#{controller_name}"
    title = t("controllers.#{controller_name}")

    [title, base].compact.join(" | ")
  end
end

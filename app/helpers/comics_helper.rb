# frozen_string_literal: true

module ComicsHelper
  def field_hint(text)
    tag.span(class: "relative ml-1 inline-flex items-center align-middle group/hint") do
      safe_join([
        tag.span(
          "(?)",
          class: "cursor-help text-lg leading-none opacity-70",
        ),
        tag.span(
          text,
          class: "pointer-events-none absolute bottom-full left-1/2 z-20 mb-1 hidden -translate-x-1/2 whitespace-nowrap rounded-md bg-black px-2 py-1 text-base text-white shadow-md group-hover/hint:block",
        ),
      ])
    end
  end
end

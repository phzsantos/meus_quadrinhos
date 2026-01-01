# frozen_string_literal: true

json.array!(@book_bindings, partial: "book_bindings/book_binding", as: :book_binding)

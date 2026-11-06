# frozen_string_literal: true

module CatalogSearch
  ACCENT_FROM = "ÁÀÂÃÄáàâãäÉÈÊËéèêëÍÌÎÏíìîïÓÒÔÕÖóòôõöÚÙÛÜúùûüÇçÑñ"
  ACCENT_TO = "AAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUUuuuuCcNn"
  LIKE_ESCAPE = "!"

  class << self
    def filter(relation, query, expression)
      tokens = normalize(query)
      return relation if tokens.empty?

      tokens.reduce(relation) do |scope, token|
        scope.where(match(expression, relation.klass, token))
      end
    end

    def coalesce(node)
      function("COALESCE", [node, quoted("")])
    end

    def cast_text(node)
      function("CAST", [node.as("text")])
    end

    private

    def match(expression, klass, token)
      pattern = "%#{klass.sanitize_sql_like(token, LIKE_ESCAPE)}%"
      folded(expression).matches(pattern, LIKE_ESCAPE, true)
    end

    def folded(expression)
      function(
        "regexp_replace",
        [
          function("translate", [function("lower", [expression]), quoted(ACCENT_FROM), quoted(ACCENT_TO)]),
          quoted("[^a-z0-9]+"),
          quoted(" "),
          quoted("g"),
        ],
      )
    end

    def normalize(query)
      query.to_s
        .unicode_normalize(:nfd)
        .gsub(/\p{Mn}/, "")
        .downcase
        .gsub(/[^a-z0-9]+/, " ")
        .squish
        .split
    end

    def function(name, args)
      Arel::Nodes::NamedFunction.new(name, args)
    end

    def quoted(value)
      Arel::Nodes.build_quoted(value)
    end
  end
end

# frozen_string_literal: true

require_relative "abstract_parslet"
require_relative "bubble"
require_relative "number"
require_relative "string"

module Chronar
  class Parser
    class Literal < AbstractParslet
      root(:literal) { boolean | void | number | string | bubble }

      rule(:boolean) { str("true").as(:true) | str("false").as(:false) } # rubocop:disable Lint/BooleanSymbol
      rule(:void) { str("void").as(:void) }
    end
  end
end

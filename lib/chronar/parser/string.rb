# frozen_string_literal: true

require_relative "abstract_parslet"

module Chronar
  class Parser
    class String < AbstractParslet
      root(:string) { str('"') >> content.as(:content) >> str('"') }
      rule(:content) { (str('\\"') | match['^"']).repeat }
    end
  end
end

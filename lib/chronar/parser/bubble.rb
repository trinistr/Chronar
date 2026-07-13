# frozen_string_literal: true

require_relative "abstract_parslet"
require_relative "expression"

module Chronar
  class Parser
    class Bubble < AbstractParslet
      root(:bubble) { str("{") >> expression >> str("}") }
    end
  end
end

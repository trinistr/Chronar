# frozen_string_literal: true

require_relative "abstract_parslet"
require_relative "assignment"
require_relative "conditional"
require_relative "expression"
require_relative "identifier"
require_relative "literal"
require_relative "method_call"
require_relative "operator"
require_relative "slot"

module Chronar
  class Parser
    class Statement < AbstractParslet
      root(:statement) {
        bracketed(expression) |
          conditional |
          assignment |
          swap_assignment |
          operator |
          method_call |
          slot |
          literal |
          identifier
      }
    end
  end
end

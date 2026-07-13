# frozen_string_literal: true

require_relative "abstract_parslet"
require_relative "identifier"
require_relative "slot"
require_relative "statement"

module Chronar
  class Parser
    class Assignment < AbstractParslet
      root(:assignment) { left_assignment | right_assignment }

      rule(:left_assignment) {
        assignment_target.as(:target) >> blanks >>
          (str("<-") | str("<=")) >>
          blanks >> right_value.as(:value)
      }
      rule(:assignment_target) { slot | identifier }
      rule(:right_value) { statement }
      rule(:right_assignment) {
        left_value.as(:value) >> blanks >>
          (str("->") | str("=>")) >>
          blanks >> assignment_target.as(:target)
      }
      # Can't be a statement due to recursion issues. Excludes assignments.
      rule(:left_value) {
        bracketed(expression) | operator | method_call | slot | literal | identifier
      }
    end

    class SwapAssignment < AbstractParslet
      root(:swap_assignment)

      rule(:swap_assignment) {
        assignment_target.as(:target_1) >> blanks >>
          (str("<->") | str("<=>")) >>
          blanks >> assignment_target.as(:target_2)
      }
      rule(:assignment_target) { slot | identifier }
    end
  end
end

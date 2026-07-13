# frozen_string_literal: true

require_relative "abstract_parslet"
require_relative "statement"

module Chronar
  class Parser
    class Conditional < AbstractParslet
      root(:conditional) {
        (str("?") >> spaces >> statement.as(:condition)) >>
          blanks >> str(":") >> spaces >> statement.as(:then) >>
          (blanks >> str(":") >> spaces >> statement).maybe.as(:else)
      }
    end
  end
end

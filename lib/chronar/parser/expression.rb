# frozen_string_literal: true

require_relative "abstract_parslet"
require_relative "comment"
require_relative "statement"

module Chronar
  class Parser
    class Expression < AbstractParslet
      root(:expression) {
        blanks >> (statement >> (blanks >> statement).repeat >> blanks).maybe
      }
    end
  end
end

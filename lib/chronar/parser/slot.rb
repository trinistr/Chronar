# frozen_string_literal: true

require_relative "abstract_parslet"

module Chronar
  class Parser
    class Slot < AbstractParslet
      root(:slot) {
        identifier.as(:root) >>
          (blanks >> str(".") >> blanks >> identifier).repeat(1).as(:path)
      }
    end
  end
end

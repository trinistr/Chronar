# frozen_string_literal: true

require_relative "abstract_parslet"
require_relative "expression"

module Chronar
  class Parser
    class AProgram < AbstractParslet
      root(:a_program) { expression }
    end
  end
end

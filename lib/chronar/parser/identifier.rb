# frozen_string_literal: true

require_relative "abstract_parslet"

module Chronar
  class Parser
    class Identifier < AbstractParslet
      root(:identifier) {
        str("@") |
          (outer_character >> (inner_character.repeat >> outer_character).repeat)
      }
      rule(:outer_character) {
        match["a-zA-Z\\u{0080}-\\u{10FFFF}"]
      }
      rule(:inner_character) {
        match["- '"]
      }
    end
  end
end

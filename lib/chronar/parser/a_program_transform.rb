# frozen_string_literal: true

require "parslet"

module Chronar
  class Parser
    class AProgramTransform < Parslet::Transform
      # Extract content of string literals and comments.
      rule({ content: simple(:str) }) { |var| var[:str] }

      # Replace single-value literals with their values.
      rule({ true => simple(:x) }) { true }
      rule({ false => simple(:x) }) { false }
      rule({ void: simple(:x) }) { :void }

      # Replace numbers with their values.
      rule({ plus: simple(:x) }) { "+" }
      rule({ minus: simple(:x) }) { "-" }
      rule({ number: subtree(:num) }) { |var|
        sign, value = var[:num].values_at(:sign, :value)
        exp = value[:exponent] || {}
        if value[:fractional]
          s = "#{sign}#{value[:integral]}.#{value[:fractional]}e#{exp[:sign]}#{exp[:integral] || 0}"
          s.to_f
        else
          "#{sign}#{value[:integral]}".to_i * 10**"#{exp[:sign]}#{exp[:integral] || 0}".to_i
        end
      }

      # Normalize argument lists into always arrays.
      rule({ slot: subtree(:slot), argument_list: simple(:empty) }) { |var|
        { slot: var[:slot], argument_list: [] }
      }
      rule({ slot: subtree(:slot), argument_list: subtree(:args) }) { |var|
        { slot: var[:slot], argument_list: [var[:args]].flatten }
      }
    end
  end
end

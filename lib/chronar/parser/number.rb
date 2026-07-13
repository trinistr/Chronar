# frozen_string_literal: true

require_relative "abstract_parslet"

module Chronar
  class Parser
    class Number < AbstractParslet
      root(:number) { sign >> value }

      rule(:sign) { (minus | plus).as(:sign) }
      rule(:plus) { str("+").maybe.as(:plus) }
      rule(:minus) { match["-−"].as(:minus) }

      rule(:value) do
        (
          integral >> str(".") >> fractional >> exponent.maybe |
          integral >> exponent.maybe
        ).as(:value)
      end
      rule(:integral) { digits.as(:integral) }
      rule(:fractional) { digits.as(:fractional) }
      rule(:digits) { digit.repeat(1) }
      rule(:digit) { match["0-9"] }

      rule(:exponent) do
        (decimal_exponent_symbol >> sign >> digits.as(:integral)).as(:exponent)
      end
      rule(:decimal_exponent_symbol) { str("e") | str("E") | str("⏨") }
    end
  end
end

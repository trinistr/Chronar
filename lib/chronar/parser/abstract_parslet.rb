# frozen_string_literal: true

require "parslet"

module Chronar
  class Parser
    class AbstractParslet < Parslet::Parser
      # Define root rule.
      # Matched content is automatically named the same.
      #
      # @param name [Symbol]
      # @yieldreturn [Parslet::Atom::Base]
      def self.root(name, &definition)
        super(name)
        rule(name) { instance_eval(&definition).as(name) }
      end

      # Create a new parslet by surrounding +parslet+ with round brackets.
      #
      # @param parslet [Parslet::Atom::Base]
      # @return [Parslet::Atom::Base]
      def bracketed(parslet)
        str("(") >> parslet >> str(")")
      end

      # Create a new parslet that matches zero or more whitespace characters,
      # comments, and newlines.
      #
      # @return [Parslet::Atom::Base]
      def blanks
        (space_separator | comment | newline).repeat
      end

      rule(:space_separator) { match["\\p{Space_Separator}\\t"] }
      rule(:spaces) { space_separator.repeat }
      rule(:newline) { str("\r").maybe >> str("\n") }

      private

      def method_missing(name, ...)
        const = Chronar::Parser.const_get(name.to_s.split("_").map(&:capitalize).join)
        # print self.class.name, ".", name, " <- ", const, "\n"
        if const.respond_to?(:new)
          self.class.rule(name) { const.new(...) }
          public_send(name)
        else
          super
        end
      end

      def respond_to_missing?(name, include_all)
        Chronar::Parser.const_defined?(name.to_s.split("_").map(&:capitalize).join) || super
      end
    end
  end
end

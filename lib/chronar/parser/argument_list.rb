# frozen_string_literal: true

require_relative "abstract_parslet"
require_relative "statement"

module Chronar
  class Parser
    class ArgumentList < AbstractParslet
      attr_reader :specifiers, :list_range, :allow_no_list

      def initialize(specifiers = [statement], list_range = (0..nil), allow_no_list: true)
        super()
        if specifiers.is_a?(Range)
          list_range = specifiers
          specifiers = [statement]
        end
        raise ArgumentError, "must use at least one specifier" if specifiers.empty?
        if list_range.end && list_range.end < specifiers.size
          raise ArgumentError, "more specifiers than allowed by list range"
        end

        @specifiers = specifiers
        @list_range = list_range
        @allow_no_list = allow_no_list
      end

      root(:argument_list) { @allow_no_list ? argument_list? : argument_list! }

      rule(:argument_list?) {
        next empty_list | no_list if @list_range.end&.zero?
        next empty_list | bracketed_list | list | no_list if @list_range.begin.zero?

        bracketed_list | list
      }
      rule(:argument_list!) {
        next empty_list if @list_range.end&.zero?
        next empty_list | bracketed_list | list if @list_range.begin.zero?

        bracketed_list | list
      }

      rule(:empty_list) { bracketed(blanks) }
      rule(:no_list) { spaces }

      rule(:bracketed_list) { bracketed(blanks >> list >> blanks) }
      rule(:list) {
        list = @specifiers.map { one_argument(_1) }
        if @list_range.end.nil?
          list << @specifiers.last.repeat(@list_range.begin - list.length)
        elsif (@list_range.end - list.length).positive?
          list << @specifiers.last.repeat(@list_range.begin - list.length,
                                          @list_range.end - list.length)
        end
        list.reduce(:>>)
      }

      private

      def one_argument(arg = statement)
        spaces >> arg >> spaces >> (str(",") >> blanks).maybe
      end
    end
  end
end

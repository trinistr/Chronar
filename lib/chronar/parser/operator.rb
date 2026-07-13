# frozen_string_literal: true

require_relative "abstract_parslet"
require_relative "argument_list"
require_relative "bubble"
require_relative "identifier"
require_relative "statement"

module Chronar
  class Parser
    class Operator < AbstractParslet
      root(:operator) {
        nullary_operator |
          prefix_operator
      }

      rule(:nullary_operator) { collapse }
      rule(:collapse) { str("!!").as(:collapse) }

      rule(:prefix_operator) {
        evaluate | mark | echo | not_collapse | timeline_split | timeline_merge | logical
      }
      rule(:evaluate) {
        (str("|") >> match["><"].absent?).as(:evaluate) >> spaces >>
          ArgumentList.new([statement], 1..1)
      }
      rule(:mark) {
        str("*").as(:mark) >> spaces >>
          ArgumentList.new([name_argument], 1..1) |
          str("*").as(:mark)
      }
      rule(:echo) {
        str("~").as(:echo) >> spaces >>
          ArgumentList.new([name_argument, statement], 2..)
      }
      rule(:not_collapse) {
        str("!").as(:not_collapse) >> spaces >>
          ArgumentList.new([statement], 1..1)
      }

      rule(:timeline_split) {
        trunk_branch | branch | split |
          trunk_branch_past | branch_past | split_past
      }
      rule(:trunk_branch) {
        str("|>").as(:trunk_branch) >> spaces >>
          ArgumentList.new([bubble_argument], 1..)
      }
      rule(:branch) {
        str(">").as(:branch) >> spaces >>
          ArgumentList.new([bubble_argument], 1..)
      }
      rule(:split) {
        str("*>").as(:split) >> spaces >>
          ArgumentList.new([bubble_argument], 1..)
      }
      rule(:trunk_branch_past) {
        str("<|").as(:trunk_branch_past) >> spaces >>
          ArgumentList.new([name_argument, bubble_argument], 2..)
      }
      rule(:branch_past) {
        str("<").as(:branch_past) >> spaces >>
          ArgumentList.new([name_argument, bubble_argument], 2..)
      }
      rule(:split_past) {
        str("<*").as(:split_past) >> spaces >>
          ArgumentList.new([name_argument, bubble_argument], 2..)
      }

      rule(:timeline_merge) {
        merge.as(:merge) >> spaces >>
          ArgumentList.new([name_argument])
      }
      rule(:merge) { str("|<") | str(">|<") | str(">|") }

      rule(:logical) { not_op | and_op | or_op }
      rule(:not_op) {
        str("not") >> spaces >>
          ArgumentList.new([statement], 1..1)
      }
      rule(:and_op) {
        str("and").as(:and) >> spaces >>
          ArgumentList.new([statement], 1..)
      }
      rule(:or_op) {
        str("or").as(:or) >> spaces >>
          ArgumentList.new([statement], 1..)
      }

      rule(:name_argument) { slot | identifier }
      rule(:bubble_argument) { bubble | method_call | identifier }
    end
  end
end

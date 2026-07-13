# frozen_string_literal: true

require_relative "parser/a_program"
require_relative "parser/a_program_transform"

module Chronar
  class Parser
    # Instantiate a new parser and parse the given program.
    def self.parse(...)
      new.parse(...)
    end

    # Parse the given program.
    #
    # @param program [String] The program to parse.
    # @return [Object] The parsed program.
    def parse(program)
      transform(raw_parse(program))
    end

    # Parse the given program without transforming the result.
    #
    # @param program [String] The program to parse.
    # @return [Object] The parsed program.
    def raw_parse(program)
      AProgram.new.parse(program)
    rescue Parslet::ParseFailed => e
      puts e.parse_failure_cause.ascii_tree
    end

    # Transform the given tree.
    #
    # @param tree [Object] The tree to transform.
    # @return [Object] The transformed tree.
    def transform(tree)
      AProgramTransform.new.apply(tree)
    end
  end
end

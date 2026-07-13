# frozen_string_literal: true

require_relative "abstract_parslet"

module Chronar
  class Parser
    class Comment < AbstractParslet
      root(:comment) { str("#") >> spaces >> (newline.absent? >> any).repeat.as(:content) }
    end
  end
end

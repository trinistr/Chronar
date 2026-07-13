# frozen_string_literal: true

require_relative "abstract_parslet"
require_relative "argument_list"
require_relative "slot"

module Chronar
  class Parser
    class MethodCall < AbstractParslet
      root(:method_call) { slot >> spaces >> ArgumentList.new(allow_no_list: false) }
    end
  end
end

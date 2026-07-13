# frozen_string_literal: true

Dir["#{__dir__}/chronar/**/*.rb"].each { require _1 }

# Prototype esoteric programming language based on splitting timelines.
module Chronar
  class Error < StandardError; end
end

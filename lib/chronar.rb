# frozen_string_literal: true

Dir["#{__dir__}/chronar/**/*.rb"].each { require _1 }

module Chronar
  class Error < StandardError; end
end

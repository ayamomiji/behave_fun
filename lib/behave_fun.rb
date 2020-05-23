require 'behave_fun/version'

require 'zeitwerk'
require 'active_support/all'

loader = Zeitwerk::Loader.for_gem
loader.setup

module BehaveFun
  module_function

  def build_builder(&block)
    BehaveFun::TaskBuilderFactory.new(&block)
  end

  class Error < StandardError; end
end

loader.eager_load

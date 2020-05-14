require 'behave_fun/version'

require 'zeitwerk'
require 'active_support/all'

loader = Zeitwerk::Loader.for_gem
loader.setup

module BehaveFun
  module_function

  def build_tree(&block)
    builder = TaskBuilder.new(Tree.new)
    builder.instance_eval(&block)
    builder.control
  end

  def build_tree_from_hash(hash)
    build_tree do
      build_from_hash(hash)
    end
  end

  def build_tree_from_json(json)
    hash = ActiveSupport::JSON.decode(json).deep_symbolize_keys
    build_tree_from_hash(hash)
  end

  def as_json(tree)
    tree.as_json
  end

  def to_json(tree)
    ActiveSupport::JSON.encode(as_json(tree))
  end

  class Error < StandardError; end
end

loader.eager_load

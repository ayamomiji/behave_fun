require 'spec_helper'

RSpec.describe BehaveFun::Decorators::Invert do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new
  }

  context 'given succeeded task' do
    it 'should invert result' do
      tree = builder.build_tree {
        invert { success }
      }
      tree.run
      expect(tree).to be_failed
    end
  end

  context 'given failed task' do
    it 'should invert result' do
      tree = builder.build_tree {
        invert { failure }
      }
      tree.run
      expect(tree).to be_succeeded
    end
  end
end

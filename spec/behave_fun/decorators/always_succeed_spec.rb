require 'spec_helper'

RSpec.describe BehaveFun::Decorators::AlwaysSucceed do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new
  }

  it 'should succeed' do
    tree = builder.build_tree {
      always_succeed { failure }
    }
    tree.run
    expect(tree).to be_succeeded
  end
end

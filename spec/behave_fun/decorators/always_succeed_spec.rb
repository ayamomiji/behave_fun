require 'spec_helper'

RSpec.describe BehaveFun::Decorators::AlwaysSucceed do
  it 'should succeed' do
    tree = BehaveFun.build_tree {
      always_succeed { failure }
    }
    tree.run
    expect(tree).to be_succeeded
  end
end

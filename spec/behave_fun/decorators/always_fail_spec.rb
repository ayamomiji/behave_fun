require 'spec_helper'

RSpec.describe BehaveFun::Decorators::AlwaysFail do
  it 'should fail' do
    tree = BehaveFun.build_tree {
      always_fail { success }
    }
    tree.run
    expect(tree).to be_failed
  end
end

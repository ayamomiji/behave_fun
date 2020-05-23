require 'spec_helper'

RSpec.describe BehaveFun::Decorators::AlwaysFail do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new
  }

  it 'should fail' do
    tree = builder.build_tree {
      always_fail { success }
    }
    tree.run
    expect(tree).to be_failed
  end
end

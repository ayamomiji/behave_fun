require 'spec_helper'

RSpec.describe BehaveFun::LeafTasks::Success do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new
  }

  it 'always succeed' do
    tree = builder.build_tree { success }
    tree.run
    expect(tree).to be_succeeded
  end
end

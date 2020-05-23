require 'spec_helper'

RSpec.describe BehaveFun::LeafTasks::Failure do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new
  }

  it 'always fail' do
    tree = builder.build_tree { failure }
    tree.run
    expect(tree).to be_failed
  end
end

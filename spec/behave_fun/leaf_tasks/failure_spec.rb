require 'spec_helper'

RSpec.describe BehaveFun::LeafTasks::Failure do
  it 'always fail' do
    tree = BehaveFun.build_tree { failure }
    tree.run
    expect(tree).to be_failed
  end
end

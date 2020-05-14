require 'spec_helper'

RSpec.describe BehaveFun::LeafTasks::Success do
  it 'always succeed' do
    tree = BehaveFun.build_tree { success }
    tree.run
    expect(tree).to be_succeeded
  end
end

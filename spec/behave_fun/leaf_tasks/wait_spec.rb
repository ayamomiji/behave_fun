require 'spec_helper'

RSpec.describe BehaveFun::LeafTasks::Wait do
  it 'delays with given count' do
    tree = BehaveFun.build_tree { wait duration: 3 }
    3.times do
      tree.run
      expect(tree).to be_running
    end
    tree.run
    expect(tree).to be_succeeded
  end
end


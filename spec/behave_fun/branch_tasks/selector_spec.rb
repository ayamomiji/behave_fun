require 'spec_helper'

RSpec.describe BehaveFun::BranchTasks::Selector do
  it 'runs until meet any succeeded' do
    tree = BehaveFun.build_tree {
      selector {
        failure
        success
      }
    }

    tree.run
    expect(tree).to be_succeeded

    tree = BehaveFun.build_tree {
      selector {
        failure
      }
    }

    tree.run
    expect(tree).to be_failed
  end
end

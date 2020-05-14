require 'spec_helper'

RSpec.describe BehaveFun::BranchTasks::Sequence do
  it 'runs until meet any failed' do
    tree = BehaveFun.build_tree {
      sequence {
        success
      }
    }

    tree.run
    expect(tree).to be_succeeded

    tree = BehaveFun.build_tree {
      sequence {
        success
        failure
      }
    }

    tree.run
    expect(tree).to be_failed
  end
end

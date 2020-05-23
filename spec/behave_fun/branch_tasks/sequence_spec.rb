require 'spec_helper'

RSpec.describe BehaveFun::BranchTasks::Sequence do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new
  }

  it 'runs until meet any failed' do
    tree = builder.build_tree {
      sequence {
        success
      }
    }

    tree.run
    expect(tree).to be_succeeded

    tree = builder.build_tree {
      sequence {
        success
        failure
      }
    }

    tree.run
    expect(tree).to be_failed
  end
end

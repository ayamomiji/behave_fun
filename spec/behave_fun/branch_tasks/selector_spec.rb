require 'spec_helper'

RSpec.describe BehaveFun::BranchTasks::Selector do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new
  }

  it 'runs until meet any succeeded' do
    tree = builder.build_tree {
      selector {
        failure
        success
      }
    }

    tree.run
    expect(tree).to be_succeeded

    tree = builder.build_tree {
      selector {
        failure
      }
    }

    tree.run
    expect(tree).to be_failed
  end
end

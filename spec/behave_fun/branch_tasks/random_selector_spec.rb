require 'spec_helper'

RSpec.describe BehaveFun::BranchTasks::RandomSelector do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new {
      add_task_type CounterTask, name: :counter
    }
  }

  it 'runs until running or succeeded' do
    tree = builder.build_tree {
      random_selector {
        always_fail { counter }
        always_succeed { counter }
      }
    }

    srand(0)
    tree.context = { counter: 0 }
    tree.run
    expect(tree.root.order).to eq([1, 0])
    expect(tree).to be_succeeded
    expect(tree.context[:counter]).to eq(1)

    tree.reset

    srand(1)
    tree.context = { counter: 0 }
    tree.run
    expect(tree.root.order).to eq([0, 1])
    expect(tree).to be_succeeded
    expect(tree.context[:counter]).to eq(2)
  end
end

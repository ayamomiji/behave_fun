require 'spec_helper'

RSpec.describe BehaveFun::BranchTasks::RandomSelector do
  it 'runs until running or succeeded' do
    tree = BehaveFun.build_tree {
      random_selector {
        always_fail { counter }
        always_succeed { counter }
      }
    }

    CounterTask.reset_counter
    srand(0)
    tree.run
    expect(tree.root.order).to eq([1, 0])
    expect(tree).to be_succeeded
    expect(CounterTask.counter).to eq(1)

    tree.reset

    CounterTask.reset_counter
    srand(1)
    tree.run
    expect(tree.root.order).to eq([0, 1])
    expect(tree).to be_succeeded
    expect(CounterTask.counter).to eq(2)
  end
end

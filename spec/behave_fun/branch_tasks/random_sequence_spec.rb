require 'spec_helper'

RSpec.describe BehaveFun::BranchTasks::RandomSequence do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new {
      add_task_type CounterTask, name: :counter
    }
  }


  it 'runs until running or succeeded' do
    tree = builder.build_tree {
      random_sequence {
        always_fail { counter }
        always_succeed { counter }
      }
    }

    CounterTask.reset_counter
    srand(0)
    tree.run
    expect(tree.root.order).to eq([1, 0])
    expect(tree).to be_failed
    expect(CounterTask.counter).to eq(2)

    tree.reset

    CounterTask.reset_counter
    srand(1)
    tree.run
    expect(tree.root.order).to eq([0, 1])
    expect(tree).to be_failed
    expect(CounterTask.counter).to eq(1)
  end
end

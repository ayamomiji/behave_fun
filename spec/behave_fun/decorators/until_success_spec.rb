require 'spec_helper'

RSpec.describe BehaveFun::Decorators::UntilSuccess do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new {
      add_task_type CounterTask, name: :counter
      add_task_type IsCounterEvenTask, name: :is_counter_even
    }
  }

  it 'should repeat until success' do
    tree = builder.build_tree {
      until_success {
        sequence {
          counter
          is_counter_even
        }
      }
    }
    tree.context = { counter: 0 }
    tree.run
    expect(tree).to be_succeeded
    expect(tree.context[:counter]).to eq(2)

    expect { tree.run }.to raise_error(BehaveFun::Error)
  end
end

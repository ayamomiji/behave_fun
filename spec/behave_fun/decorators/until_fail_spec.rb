require 'spec_helper'

RSpec.describe BehaveFun::Decorators::UntilFail do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new {
      add_task_type CounterTask, name: :counter
      add_task_type IsCounterEvenTask, name: :is_counter_even
    }
  }

  it 'should repeat until fail' do
    tree = builder.build_tree {
      until_fail {
        sequence {
          counter
          is_counter_even
        }
      }
    }
    tree.context = { counter: 1 }
    tree.run
    expect(tree).to be_succeeded
    expect(tree.context[:counter]).to eq(3)

    expect { tree.run }.to raise_error(BehaveFun::Error)
  end
end

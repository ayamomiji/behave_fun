require 'spec_helper'

RSpec.describe BehaveFun::Decorators::Repeat do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new {
      add_task_type CounterTask, name: :counter
    }
  }

  it 'should repeat given times' do
    tree = builder.build_tree {
      repeat(times: 3) { counter }
    }
    tree.context = { counter: 0 }
    tree.run
    expect(tree).to be_succeeded
    expect(tree.context[:counter]).to eq(3)

    expect { tree.run }.to raise_error(BehaveFun::Error)
  end

  it 'repeats forever if times was omitted' do
    tree = builder.build_tree {
      repeat {
        sequence {
          counter
          wait duration: 1
        }
      }
    }
    tree.context = { counter: 0 }
    tree.run
    expect(tree).to be_running
    expect(tree.context[:counter]).to eq(1)
  end
end

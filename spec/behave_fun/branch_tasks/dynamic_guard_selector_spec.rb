require 'spec_helper'

RSpec.describe BehaveFun::BranchTasks::DynamicGuardSelector do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new {
      add_task_type SetTask, name: :set
      add_task_type IsValueEqualsTask, name: :is_value_equals
    }
  }

  it 'switch current child according guard result' do
    SetTask.reset_value

    tree = builder.build_tree {
      dynamic_guard_selector {
        sequence {
          guard_with { is_value_equals value: 'alive' }
          set value: 'alive'
          invert { wait duration: 9 } # simulate a long task
        }
        sequence {
          guard_with { is_value_equals value: 'dead' }
          set value: 'dead'
          wait duration: 9 # simulate a long task
        }
      }
    }

    # set initial data
    tree.context = { value: 'alive' }
    # run several times before task ended...
    5.times do
      tree.run
      expect(SetTask.value).to eq('alive')
      expect(tree).to be_running
    end
    # then change the data
    tree.context = { value: 'dead' }
    # it should switch immediately
    5.times do
      tree.run
      expect(SetTask.value).to eq('dead')
      expect(tree).to be_running
    end
    # trying to switch back
    tree.context = { value: 'alive' }
    9.times do
      tree.run
      expect(SetTask.value).to eq('alive')
      expect(tree).not_to be_ended
    end
    # until it ends, return the result
    tree.run
    expect(tree).to be_failed
  end
end

require 'spec_helper'

RSpec.describe BehaveFun::BranchTasks::DynamicGuardSelector do
  it 'switch current child according guard result' do
    SetTask.reset_value

    tree = BehaveFun.build_tree {
      dynamic_guard_selector {
        sequence {
          set value: 'alive'
          invert { wait duration: 9 } # simulate a long task
        }
        sequence {
          set value: 'dead'
          wait duration: 9 # simulate a long task
        }
      }
    }
    is_alive = BehaveFun.build_tree { is_data_equals value: 'alive' }
    is_dead = BehaveFun.build_tree { is_data_equals value: 'dead' }
    tree.root.children[0].guard = is_alive
    tree.root.children[1].guard = is_dead

    # set initial data
    tree.data = 'alive'
    # run several times before task ended...
    5.times do
      tree.run
      expect(SetTask.value).to eq('alive')
      expect(tree).to be_running
    end
    # then change the data
    tree.data = 'dead'
    # it should switch immediately
    5.times do
      tree.run
      expect(SetTask.value).to eq('dead')
      expect(tree).to be_running
    end
    # trying to switch back
    tree.data = 'alive'
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

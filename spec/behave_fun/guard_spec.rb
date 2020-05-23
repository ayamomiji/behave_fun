require 'spec_helper'

RSpec.describe BehaveFun::Task do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new {
      add_task_type CounterTask, name: :counter
    }
  }

  describe '#guard_passed?' do
    it 'returns true while guard succeeds' do
      guard = builder.build_tree { success }
      task = builder.build_tree { success }
      task.guard = guard
      expect(task).to be_guard_passed
    end

    it 'returns false while guard fails' do
      guard = builder.build_tree { failure }
      task = builder.build_tree { success }
      task.guard = guard
      expect(task).not_to be_guard_passed
    end

    it 'raises error if guard is still running' do
      guard = builder.build_tree { wait duration: 3 }
      task = builder.build_tree { success }
      task.guard = guard
      expect { task.guard_passed? }.to raise_error(BehaveFun::Error)
    end

    it 'caches guard result while task running' do
      CounterTask.reset_counter

      guard = builder.build_tree { counter }
      task = builder.build_tree { wait duration: 3 }
      task.guard = guard

      3.times { task.run }
      expect(CounterTask.counter).to eq(1)

      task.reset

      3.times { task.run }
      expect(CounterTask.counter).to eq(2)
    end
  end
end

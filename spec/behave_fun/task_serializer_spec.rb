RSpec.describe BehaveFun do
  describe 'Task#as_json and .build_tree_from_json' do
    it 'dumpable and restorable' do
      original_tree = BehaveFun.build_tree {
        sequence {
          success
          wait duration: 3
          failure
        }
      }

      json = BehaveFun.to_json(original_tree)
      # ensure it is valid json
      expect {
        ActiveSupport::JSON.decode(json)
      }.not_to raise_error
      # restore from json
      tree = BehaveFun.build_tree_from_json(json)

      expect(tree).to be_a(BehaveFun::Tree)
      expect(tree.root).to be_a(BehaveFun::BranchTasks::Sequence)
      expect(tree.root.children[0]).to be_a(BehaveFun::LeafTasks::Success)
      expect(tree.root.children[1]).to be_a(BehaveFun::LeafTasks::Wait)
      expect(tree.root.children[1].params).to eq(duration: 3)
      expect(tree.root.children[2]).to be_a(BehaveFun::LeafTasks::Failure)
    end

    it 'works with guard' do
      original_tree = BehaveFun.build_tree {
        sequence {
          guard_with { success }
          success
        }
      }

      json = BehaveFun.to_json(original_tree)
      # ensure it is valid json
      expect {
        ActiveSupport::JSON.decode(json)
      }.not_to raise_error
      # restore from json
      tree = BehaveFun.build_tree_from_json(json)

      expect(tree).to be_a(BehaveFun::Tree)
      expect(tree.root).to be_a(BehaveFun::BranchTasks::Sequence)
      expect(tree.root.guard).to be_a(BehaveFun::LeafTasks::Success)
      expect(tree.root.children[0]).to be_a(BehaveFun::LeafTasks::Success)
    end
  end

  describe '.build_task_from_hash' do
    it 'builds task' do
      original_tree = BehaveFun.build_task {
        sequence {
          success
          wait duration: 3
          failure
        }
      }
      hash = original_tree.as_json
      task = BehaveFun.build_task_from_hash(hash)
      expect(task).to be_a(BehaveFun::BranchTasks::Sequence)
      expect(task.children[0]).to be_a(BehaveFun::LeafTasks::Success)
      expect(task.children[1]).to be_a(BehaveFun::LeafTasks::Wait)
      expect(task.children[2]).to be_a(BehaveFun::LeafTasks::Failure)
    end
  end

  describe '.dump_status and .restore_status' do
    it 'dumpable and restorable' do
      original_tree = BehaveFun.build_tree {
        sequence {
          success
          wait duration: 3
          failure
        }
      }

      original_tree.run
      original_tree.run
      expect(original_tree.root.current_child_idx).to eq(1)
      expect(original_tree.root.children[1]).to be_running
      expect(original_tree.root.children[1].counter).to eq(2)

      status_data = original_tree.dump_status

      # clone tree
      tree = BehaveFun.build_tree_from_json(BehaveFun.to_json(original_tree))

      # restore from json
      tree.restore_status(status_data)
      expect(tree.root.current_child_idx).to eq(1)
      expect(tree.root.children[1]).to be_running
      expect(tree.root.children[1].counter).to eq(2)
    end
  end
end

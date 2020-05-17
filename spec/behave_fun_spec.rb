RSpec.describe BehaveFun do
  describe '.build_tree' do
    it 'can build a simple tree' do
      tree = BehaveFun.build_tree { success }

      expect(tree).to be_a(BehaveFun::Tree)
      expect(tree.root).to be_a(BehaveFun::LeafTasks::Success)
      expect(tree.root.control).to be(tree)
    end

    it 'can build a complex tree' do
      tree = BehaveFun.build_tree {
        sequence {
          success
          wait duration: 3
          failure
        }
      }

      expect(tree).to be_a(BehaveFun::Tree)
      expect(tree.root.children[0]).to be_a(BehaveFun::LeafTasks::Success)
      expect(tree.root.children[1]).to be_a(BehaveFun::LeafTasks::Wait)
      expect(tree.root.children[1].params).to eq(duration: 3)
      expect(tree.root.children[2]).to be_a(BehaveFun::LeafTasks::Failure)
    end

    it 'can build a more complex tree with guard' do
      tree = BehaveFun.build_tree {
        sequence {
          guard_with { success }
          success
        }
      }

      expect(tree).to be_a(BehaveFun::Tree)
      expect(tree.root.guard).to be_a(BehaveFun::LeafTasks::Success)
    end

    it 'supports include sub-task' do
      sub_task = BehaveFun.build_task { success }
      tree = BehaveFun.build_tree {
        include sub_task
      }
      expect(tree.root).to be_a(BehaveFun::LeafTasks::Success)
    end

    it 'supports include sub-task many times' do
      sub_task = BehaveFun.build_task { success }
      tree = BehaveFun.build_tree {
        selector {
          always_succeed { include sub_task }
          always_succeed { include sub_task }
          always_succeed { include sub_task }
        }
      }
      expect(tree.root.children[0].children[0]).to be_a(BehaveFun::LeafTasks::Success)
      expect(tree.root.children[0].children[0].control).to be(tree.root.children[0])
      expect(tree.root.children[1].children[0]).to be_a(BehaveFun::LeafTasks::Success)
      expect(tree.root.children[1].children[0].control).to be(tree.root.children[1])
      expect(tree.root.children[2].children[0]).to be_a(BehaveFun::LeafTasks::Success)
      expect(tree.root.children[2].children[0].control).to be(tree.root.children[2])
    end
  end

  describe '.build_task' do
    it 'returns built task' do
      task = BehaveFun.build_task { success }
      expect(task).to be_a(BehaveFun::LeafTasks::Success)
      expect(task.control).to be_nil
    end
  end
end

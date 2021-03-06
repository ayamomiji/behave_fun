RSpec.describe BehaveFun::TaskBuilderFactory do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new
  }

  describe '#build_tree' do
    it 'can build a simple tree' do
      tree = builder.build_tree { success }

      expect(tree).to be_a(BehaveFun::Tree)
      expect(tree.root).to be_a(BehaveFun::LeafTasks::Success)
      expect(tree.root.control).to be(tree)
    end

    it 'can build a complex tree' do
      tree = builder.build_tree {
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
      tree = builder.build_tree {
        sequence {
          guard_with { success }
          success
        }
      }

      expect(tree).to be_a(BehaveFun::Tree)
      expect(tree.root.guard).to be_a(BehaveFun::LeafTasks::Success)
    end

    it 'supports include sub-task' do
      sub_task = builder.build_task { success }
      tree = builder.build_tree {
        include sub_task
      }
      expect(tree.root).to be_a(BehaveFun::LeafTasks::Success)
    end

    it 'supports include sub-task many times' do
      sub_task = builder.build_task { success }
      tree = builder.build_tree {
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

  describe '#build_task' do
    it 'returns built task' do
      task = builder.build_task { success }
      expect(task).to be_a(BehaveFun::LeafTasks::Success)
      expect(task.control).to be_nil
    end
  end

  describe '#build_tree_from_hash' do
    it 'builds tree from hash' do
      tree_data = {
        'version': 1,
        'root' => {
          'type' => 'sequence',
          'children' => [
            { 'type' => 'success' }
          ]
        }
      }
      tree = builder.build_tree_from_hash(tree_data)
      expect(tree).to be_a(BehaveFun::Tree)
      expect(tree.root).to be_a(BehaveFun::BranchTasks::Sequence)
      expect(tree.root.children[0]).to be_a(BehaveFun::LeafTasks::Success)
    end
  end

  describe '#build_task_from_hash' do
    it 'builds tree from hash' do
      task_data = {
        'type' => 'sequence',
        'children' => [
          { 'type' => 'success' }
        ]
      }
      task = builder.build_task_from_hash(task_data)
      expect(task).to be_a(BehaveFun::BranchTasks::Sequence)
      expect(task.children[0]).to be_a(BehaveFun::LeafTasks::Success)
    end
  end
end

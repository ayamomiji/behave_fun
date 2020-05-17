require 'spec_helper'

RSpec.describe BehaveFun::Decorators::Repeat do
  it 'should repeat given times' do
    tree = BehaveFun.build_tree {
      repeat(times: 3) { success }
    }
    tree.run
    expect(tree).to be_running
    tree.run
    expect(tree).to be_running
    tree.run
    expect(tree).to be_succeeded

    expect { tree.run }.to raise_error(BehaveFun::Error)
  end

  it 'repeats forever if times was omitted' do
    tree = BehaveFun.build_tree {
      repeat { success }
    }
    3.times do
      tree.run
      # the counter should not be increased
      expect(tree.root.counter).to eq(0)
      expect(tree).to be_running
    end
  end
end

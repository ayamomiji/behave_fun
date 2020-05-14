require 'spec_helper'

RSpec.describe BehaveFun::Decorators::UntilFail do
  it 'should repeat until fail' do
    tree = BehaveFun.build_tree {
      until_fail { invert { wait(duration: 3) } }
    }
    3.times do
      tree.run
      expect(tree).to be_running
    end
    tree.run
    expect(tree).to be_succeeded

    expect { tree.run }.to raise_error(BehaveFun::Error)
  end
end

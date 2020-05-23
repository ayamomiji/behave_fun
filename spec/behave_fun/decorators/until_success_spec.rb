require 'spec_helper'

RSpec.describe BehaveFun::Decorators::UntilSuccess do
  let(:builder) {
    BehaveFun::TaskBuilderFactory.new
  }

  it 'should repeat until success' do
    tree = builder.build_tree {
      until_success { wait(duration: 3) }
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

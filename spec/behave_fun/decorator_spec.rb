require 'spec_helper'

RSpec.describe BehaveFun::Decorator do
  describe '#run' do
    it 'starts child if child not running' do
      decorator = BehaveFun::Decorator.new
      child = BehaveFun::Task.new
      decorator.add_child(child)
      expect(child).to receive(:run)
      decorator.run
    end
  end

  describe '#add_child' do
    it 'cannot have more than one child' do
      decorator = BehaveFun::Decorator.new
      child = BehaveFun::Task.new
      child2 = BehaveFun::Task.new
      expect { decorator.add_child(child) }.not_to raise_error
      expect { decorator.add_child(child2) }.to raise_error(BehaveFun::Error)
    end
  end
end

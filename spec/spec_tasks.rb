class CounterTask < BehaveFun::Task
  def execute
    thread = Thread.current
    thread[:counter] ||= 0
    thread[:counter] += 1
    success
  end

  def self.counter
    Thread.current[:counter]
  end

  def self.reset_counter
    Thread.current[:counter] = 0
  end

  add_to_task_builder :counter
end

class IsCounterEvenTask < BehaveFun::Task
  def execute
    Thread.current[:counter].even? ? success : fail
  end

  add_to_task_builder :is_counter_even
end

class SetTask < BehaveFun::Task
  attr_accessor :value

  def initialize(value: )
    super
    @value = value
  end

  def execute
    Thread.current[:value] = value
    success
  end

  def self.value
    Thread.current[:value]
  end

  def self.reset_value
    Thread.current[:value] = nil
  end

  add_to_task_builder :set
end

class IsDataEqualsTask < BehaveFun::Task
  attr_accessor :value

  def initialize(value: )
    super
    @value = value
  end

  def execute
    tree.data == value ? success : fail
  end

  add_to_task_builder :is_data_equals
end

# BehaveFun

BehaveFun is a behavior tree library for Ruby.

Inspired by [gdx-ai's behavior trees](https://github.com/libgdx/gdx-ai/wiki/Behavior-Trees).

Main features:

* Build behavior tree from Ruby and JSON.
* Serialize tree status data and can be restored later.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'behave_fun'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install behave_fun
```

## Usage

To build a behavior tree:

``` ruby
builder = BehaveFun.build_builder {
  # add_task_type YourCustomTask
}
# ruby dsl
tree = builder.build_tree { success }
# from hash
tree = builder.build_tree_from_hash(type: :success)
# from json
tree = builder.build_tree_from_json(json_string)
```

To build a complex behavior tree:

``` ruby
# write_spec, write_code, run_spec, git_push and release_gem are customized tasks
tree = builder.build_tree {
  sequence {
    until_success {
      sequence {
        write_spec
        write_code
        run_spec
      }
    }
    git_push
    release_gem
  }
}
```

To create customized task, create a class that extends `BehaveFun::Task` (or use a lambda if only need to overwrite `#execute` method). Don't forget call `running` `success` or `fail` in `#execute` method at the end.

``` ruby
# a task that increase data by 1, always success
class Counter < BehaveFun::Task
  def execute
    context[:counter] += 1
    success
  end
end

# a task that detect tree data is even or not
is_counter_even = -> { context[:counter].even? ? success : fail }

# add these tasks to your builder
builder = BehaveFun.build_builder {
  add_task_type Counter
  add_lambda_task_type :is_counter_even, &is_counter_even
}
builder.build_tree { counter }
```

To run a tree:

``` ruby
tree.context = { ... } # provide your context (data) for the tree
tree.run
tree.status # :running, :succeeded or :failed
```

To dump and restore status:

``` ruby
status = tree.dump_status # a hash that contains entire tree's status
tree.restore_status(status)
```

For more detail, see spec examples.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ayamomiji/behave_fun. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ayamomiji/behave_fun/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the BehaveFun project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ayamomiji/behave_fun/blob/master/CODE_OF_CONDUCT.md).

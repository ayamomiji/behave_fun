RSpec.describe 'lambda task' do
  let(:builder) {
    BehaveFun.build_builder {}
  }

  it 'works' do
    increment = -> {
      context[:counter] += params[:by]
      success
    }
    builder = BehaveFun.build_builder {
      add_lambda_task_type :increment, &increment
    }

    tree = builder.build_tree {
      increment by: 3
    }

    tree.context = { counter: 0 }
    tree.run
    expect(tree.context[:counter]).to eq(3)
  end
end

# defmodule ContextDemoTest do
#   use ExUnit.Case
#
#   setup(context) do
#     IO.inspect context
#   end
#
#   describe "context" do
#     setup(context) do
#       IO.inspect context
#     end
#
#     test "assert true" do
#       assert true
#     end
#   end
# end

defmodule MyModuleTest do
  use ExUnit.Case

  setup do
    [book: %Book{title: "The Wastelands"}]
  end

  test "the_truth", context do
    IO.inspect(context)

    assert true
  end
end

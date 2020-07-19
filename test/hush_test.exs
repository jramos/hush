defmodule HushTest do
  use ExUnit.Case
  doctest Hush

  test "release_mode? is false" do
    assert Hush.release_mode?() == false
  end

  test "resolve!()" do
    Application.put_env(:hush, :test_resolve_1, {:hush, Hush.Provider.Echo, "bar"})

    assert Hush.resolve!()[:hush][:test_resolve_1] == "bar"
  end

  test "resolve!(config)" do
    config = [
      {:app, [foo: {:hush, Hush.Provider.Echo, "bar"}]}
    ]

    assert Hush.resolve!(config) == [{:app, [foo: "bar"]}]
  end

  test "resolve!(config) with invalid provider config" do
    config = [
      {:hush, [providers: [Hush.Provider.LoadFail]]}
    ]

    assert_raise(
      ArgumentError,
      "Could not load provider Elixir.Hush.Provider.LoadFail: fail",
      fn -> Hush.resolve!(config) == [{:app, [foo: "bar"]}] end
    )
  end
end

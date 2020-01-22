defmodule Surface.DirectivesTest do
  use ExUnit.Case
  use Phoenix.ConnTest

  import Surface
  import ComponentTestHelper

  setup_all do
    Endpoint.start_link()
    :ok
  end

  defmodule Div do
    use Surface.Component

    def render(assigns) do
      ~H"""
      <div>{{ @inner_content.() }}</div>
      """
    end
  end

  describe ":for" do
    test "in components" do
      assigns = %{items: [1, 2]}
      code =
        """
        <Div :for={{ i <- @items }}>
          Item: {{i}}
        </Div>
        """

      assert render_live(code, assigns) =~ """
      <div>
        Item: 1
      </div><div>
        Item: 2
      </div>
      """
    end

    test "in html tags" do
      assigns = %{items: [1, 2]}
      code =
        """
        <div :for={{ i <- @items }}>
          Item: {{i}}
        </div>
        """

      assert render_live(code, assigns) =~ """
      <div>
        Item: 1
      </div><div>
        Item: 2
      </div>
      """
    end

    test "in void html elements" do
      assigns = %{}
      code =
        ~H"""
        <br :for={{ _ <- [1,2] }}>
        """

      assert render_static(code) == """
      <br><br>
      """
    end
  end

  describe ":if" do
    test "in components" do
      assigns = %{show: true, dont_show: false}
      code =
        """
        <Div :if={{ @show }}>
          Show
        </Div>
        <Div :if={{ @dont_show }}>
          Dont's show
        </Div>
        """

      assert render_live(code, assigns) == """
      <div>
        Show
      </div>
      """
    end

    test "in html tags" do
      assigns = %{show: true, dont_show: false}
      code =
        ~H"""
        <div :if={{ @show }}>
          Show
        </div>
        <div :if={{ @dont_show }}>
          Dont's show
        </div>
        """

      assert render_static(code) =~ """
      <div>
        Show
      </div>
      """
    end

    test "in void html elements" do
      assigns = %{show: true, dont_show: false}
      code =
        ~H"""
        <col class="show" :if={{ @show }}>
        <col class="dont_show" :if={{ @dont_show }}>
        """

      assert render_static(code) == """
      <col class="show">
      """
    end
  end
end


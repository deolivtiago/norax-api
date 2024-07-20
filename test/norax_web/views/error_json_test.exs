defmodule NoraxWeb.ErrorJSONTest do
  use NoraxWeb.ConnCase, async: true

  alias NoraxWeb.ErrorJSON

  test "renders 500" do
    assert %{errors: errors} = ErrorJSON.render("500.json", %{})

    assert errors == %{detail: "Internal Server Error"}
  end
end

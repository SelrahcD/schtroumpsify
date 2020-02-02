defmodule SchtroumpsifyWeb.PageControllerTest do
  use SchtroumpsifyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Schtroumpsify"
  end
end

defmodule WebsFlyerWeb.API.UserAttributionControllerTest do
  use WebsFlyerWeb.ConnCase

  alias WebsFlyer.Affiliates
  alias WebsFlyer.Affiliates.Schemas.UserAttribution

  @create_attrs %{attributed_to: "some attributed_to", attribution_start_timestamp: 42, attribution_window_in_seconds: 42, user_cookie: "some user_cookie", user_id: 42}
  @update_attrs %{attributed_to: "some updated attributed_to", attribution_start_timestamp: 43, attribution_window_in_seconds: 43, user_cookie: "some updated user_cookie", user_id: 43}
  @invalid_attrs %{attributed_to: nil, attribution_start_timestamp: nil, attribution_window_in_seconds: nil, user_cookie: nil, user_id: nil}

  def fixture(:user_attribution) do
    {:ok, user_attribution} = Affiliates.UserAttributions.create_user_attribution(@create_attrs)
    user_attribution
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all user_attributions", %{conn: conn} do
      conn = get conn, api_user_attribution_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user_attribution" do
    test "renders user_attribution when data is valid", %{conn: conn} do
      conn = post conn, api_user_attribution_path(conn, :create), user_attribution: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_user_attribution_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "attributed_to" => "some attributed_to",
        "attribution_start_timestamp" => 42,
        "attribution_window_in_seconds" => 42,
        "user_cookie" => "some user_cookie",
        "user_id" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_user_attribution_path(conn, :create), user_attribution: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user_attribution" do
    setup [:create_user_attribution]

    test "renders user_attribution when data is valid", %{conn: conn, user_attribution: %UserAttribution{id: id} = user_attribution} do
      conn = put conn, api_user_attribution_path(conn, :update, user_attribution), user_attribution: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_user_attribution_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "attributed_to" => "some updated attributed_to",
        "attribution_start_timestamp" => 43,
        "attribution_window_in_seconds" => 43,
        "user_cookie" => "some updated user_cookie",
        "user_id" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, user_attribution: user_attribution} do
      conn = put conn, api_user_attribution_path(conn, :update, user_attribution), user_attribution: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user_attribution" do
    setup [:create_user_attribution]

    test "deletes chosen user_attribution", %{conn: conn, user_attribution: user_attribution} do
      conn = delete conn, api_user_attribution_path(conn, :delete, user_attribution)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_user_attribution_path(conn, :show, user_attribution)
      end
    end
  end

  defp create_user_attribution(_) do
    user_attribution = fixture(:user_attribution)
    {:ok, user_attribution: user_attribution}
  end
end

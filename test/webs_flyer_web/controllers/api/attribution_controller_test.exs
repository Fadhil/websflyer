defmodule WebsFlyerWeb.API.AttributionControllerTest do
  use WebsFlyerWeb.ConnCase

  alias WebsFlyer.Affiliates
  alias WebsFlyer.Affiliates.Attribution

  @create_attrs %{aff_name: "some aff_name", event: "some event", rs_id: 42, s2s_post_params: "some s2s_post_params", status: "some status", transaction_id: "some transaction_id", url_params: "some url_params", user_cookie: "some user_cookie", user_id: 42}
  @update_attrs %{aff_name: "some updated aff_name", event: "some updated event", rs_id: 43, s2s_post_params: "some updated s2s_post_params", status: "some updated status", transaction_id: "some updated transaction_id", url_params: "some updated url_params", user_cookie: "some updated user_cookie", user_id: 43}
  @invalid_attrs %{aff_name: nil, event: nil, rs_id: nil, s2s_post_params: nil, status: nil, transaction_id: nil, url_params: nil, user_cookie: nil, user_id: nil}

  def fixture(:attribution) do
    {:ok, attribution} = Affiliates.create_attribution(@create_attrs)
    attribution
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all attributions", %{conn: conn} do
      conn = get conn, api_attribution_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create attribution" do
    test "renders attribution when data is valid", %{conn: conn} do
      conn = post conn, api_attribution_path(conn, :create), attribution: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_attribution_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "aff_name" => "some aff_name",
        "event" => "some event",
        "rs_id" => 42,
        "s2s_post_params" => "some s2s_post_params",
        "status" => "some status",
        "transaction_id" => "some transaction_id",
        "url_params" => "some url_params",
        "user_cookie" => "some user_cookie",
        "user_id" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_attribution_path(conn, :create), attribution: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update attribution" do
    setup [:create_attribution]

    test "renders attribution when data is valid", %{conn: conn, attribution: %Attribution{id: id} = attribution} do
      conn = put conn, api_attribution_path(conn, :update, attribution), attribution: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_attribution_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "aff_name" => "some updated aff_name",
        "event" => "some updated event",
        "rs_id" => 43,
        "s2s_post_params" => "some updated s2s_post_params",
        "status" => "some updated status",
        "transaction_id" => "some updated transaction_id",
        "url_params" => "some updated url_params",
        "user_cookie" => "some updated user_cookie",
        "user_id" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, attribution: attribution} do
      conn = put conn, api_attribution_path(conn, :update, attribution), attribution: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete attribution" do
    setup [:create_attribution]

    test "deletes chosen attribution", %{conn: conn, attribution: attribution} do
      conn = delete conn, api_attribution_path(conn, :delete, attribution)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_attribution_path(conn, :show, attribution)
      end
    end
  end

  defp create_attribution(_) do
    attribution = fixture(:attribution)
    {:ok, attribution: attribution}
  end
end

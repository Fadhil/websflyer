defmodule WebsFlyerWeb.API.AttributionControllerTest do
  use WebsFlyerWeb.ConnCase

  alias WebsFlyer.Affiliates
  alias WebsFlyer.Affiliates.Attribution

  @doc """
  @anonymous_click_attrs are for when users hit the site with ?utm_source source
  params before having logged in
  """
  @anonymous_click_attrs %{
    url_params: "?utm_source=some_affiliate",
    user_id: nil,
    user_cookie: "randomcookie"
  }
  @create_attrs %{
    aff_name: "some aff_name",
    event: "some event",
    rs_id: 42,
    s2s_post_params: "some s2s_post_params",
    status: "some status",
    transaction_id: "some transaction_id",
    url_params: "param1=test1&param2=test2",
    user_cookie: "some user_cookie",
    user_id: 42
  }
  @update_attrs %{
    aff_name: "some updated aff_name",
    event: "some updated event",
    rs_id: 43,
    s2s_post_params: "some updated s2s_post_params",
    status: "some updated status",
    transaction_id: "some updated transaction_id",
    url_params: "some updated url_params",
    user_cookie: "some updated user_cookie",
    user_id: 43
  }
  @invalid_attrs %{
    aff_name: nil,
    event: nil,
    rs_id: nil,
    s2s_post_params: nil,
    status: nil,
    transaction_id: nil,
    url_params: nil,
    user_cookie: nil,
    user_id: nil
  }

  def fixture(:attribution) do
    {:ok, attribution} = Affiliates.create_attribution(@create_attrs)
    attribution
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all attributions", %{conn: conn} do
      conn = get(conn, api_attribution_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create attribution with url_params and user_cookie and user_id is nil" do
    test "renders attribution with aff_name, event type 'click', user_cookie, url_params, and timestamps",
         %{conn: conn} do
      conn = post(conn, api_attribution_path(conn, :create), attribution: @anonymous_click_attrs)
      assert %{
               "id" => _id,
               "url_params" => "?utm_source=some_affiliate",
               "user_cookie" => "randomcookie",
               "aff_name" => "some_affiliate",
               "event" => "click"
             } = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, api_attribution_path(conn, :create), attribution: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update attribution" do
    setup [:create_attribution]

    test "renders a 404 error", %{conn: conn, attribution: %Attribution{id: id} = _attribution} do
      assert_error_sent(404, fn ->
        put(conn, "/api/attributions/#{id}", attribution: @update_attrs)
      end)
    end
  end

  describe "delete attribution" do
    setup [:create_attribution]

    test "deletes chosen attribution", %{conn: conn, attribution: attribution} do
      assert_error_sent(404, fn ->
        delete(conn, "/api/attributions/#{attribution.id}")
      end)
    end
  end

  defp create_attribution(_) do
    attribution = fixture(:attribution)
    {:ok, attribution: attribution}
  end
end

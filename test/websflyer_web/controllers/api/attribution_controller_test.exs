defmodule WebsflyerWeb.API.AttributionControllerTest do
  use WebsflyerWeb.ConnCase

  alias Websflyer.Affiliates.Schemas.{Attribution, UserAttribution}
  alias Websflyer.Affiliates.{Attributions, MediaSources, UserAttributions}
  alias Websflyer.TestData
  alias Websflyer.Repo

  def fixture(:attribution) do
    {:ok, [attribution, _user_attribution]} =
      Attributions.create_attribution(TestData.create_attrs())

    attribution
  end

  setup %{conn: conn} do
    {:ok, _media_source} = MediaSources.create_media_source(TestData.shopback_media_source())
    {:ok, _click_attribution} = Attributions.create_attribution(TestData.click_shopback_attrs())
    {:ok, _login_attribution} = Attributions.create_attribution(TestData.login_user_1234_attrs())

    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all attributions", %{conn: conn} do
      conn = get(conn, api_attribution_path(conn, :index))
      assert [_head | _tail] = json_response(conn, 200)["data"]
    end
  end

  describe "create click attribution" do
    test "with url_params and user_cookie and user_id is nil renders click attribution with valid details",
         %{conn: conn} do
      conn =
        post(conn, api_attribution_path(conn, :create),
          attribution: TestData.anonymous_click_attrs()
        )

      assert %{
               "id" => _id,
               "url_params" => "?utm_source=some_affiliate",
               "user_cookie" => "randomcookie",
               "aff_name" => "some_affiliate",
               "event" => "click",
               "created_at" => _created_at
             } = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, api_attribution_path(conn, :create), attribution: TestData.invalid_attrs())

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "with url_params but user_cookie is nil renders a 422 error", %{conn: conn} do
      conn =
        post(conn, api_attribution_path(conn, :create),
          attribution: TestData.invalid_click_attrs()
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "with user_cookie but url_params and user_id is nil renders a 422 error", %{conn: conn} do
      conn =
        post(conn, api_attribution_path(conn, :create),
          attribution: TestData.invalid_click_attrs2()
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "create login attribution" do
    test "with valid details renders login attribution", %{conn: conn} do
      post(conn, api_attribution_path(conn, :create), attribution: TestData.valid_login_attrs())
      assert %{"event" => "login", "user_cookie" => "randomusercookie", "user_id" => 3}
    end

    test "with url_params but user_cookie is nil renders a 422 error", %{conn: conn} do
      conn =
        post(conn, api_attribution_path(conn, :create),
          attribution: TestData.invalid_login_without_user_cookie_attrs()
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "with user_cookie but url_params and user_id is nil renders a 422 error", %{conn: conn} do
      conn =
        post(conn, api_attribution_path(conn, :create),
          attribution: TestData.invalid_login_without_user_id_attrs()
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "create transaction attribution" do
    test "with valid details when a user_attribution with the user_id exists renders transaction attribution ",
         %{conn: conn} do
      assert {:ok, %UserAttribution{} = _user_attribution} =
               UserAttributions.create_user_attribution(TestData.click_now_user_attribution())

      conn =
        post(conn, api_attribution_path(conn, :create),
          attribution: TestData.transaction_user_1234_attrs()
        )

      assert json_response(conn, 201)["data"] != %{}
    end

    test "with valid details when user_attribution with the user_id does not exist", %{conn: conn} do
      UserAttribution |> Repo.delete_all()

      conn =
        post(conn, api_attribution_path(conn, :create),
          attribution: TestData.transaction_user_1234_attrs()
        )

      assert json_response(conn, 200)
    end

    test "with user_id but rs_id is nil renders a 422 error", %{conn: conn} do
      conn =
        post(conn, api_attribution_path(conn, :create),
          attribution: TestData.invalid_transaction_without_rs_id_attrs()
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "with rs_id and user_id is nil renders a 422 error", %{conn: conn} do
      conn =
        post(conn, api_attribution_path(conn, :create),
          attribution: TestData.invalid_transaction_without_user_id_attrs()
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update attribution" do
    setup [:create_attribution]

    test "renders a 404 error", %{conn: conn, attribution: %Attribution{id: id} = _attribution} do
      assert_error_sent(404, fn ->
        put(conn, "/api/attributions/#{id}", attribution: TestData.update_attrs())
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

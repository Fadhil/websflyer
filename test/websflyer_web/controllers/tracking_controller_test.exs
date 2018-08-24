defmodule WebsflyerWeb.TrackingControllerTest do
  use WebsflyerWeb.ConnCase

  alias Websflyer.Affiliates.Schemas.{Attribution, UserAttribution}
  alias Websflyer.Affiliates.{Attributions, MediaSources}
  alias Websflyer.TestData
  alias Websflyer.Repo

  setup %{conn: conn} do
    {:ok, _media_source} = MediaSources.create_media_source(TestData.shopback_media_source())
    {:ok, _click_attribution} = Attributions.create_attribution(TestData.click_shopback_attrs())
    {:ok, _login_attribution} = Attributions.create_attribution(TestData.login_user_1234_attrs())

    {:ok, conn: conn}
  end

  describe "tracker" do
    test "when user_attribution with a user_cookie is set, and user_id is sent in params, the user_attribution is updated with the user_id",
         %{conn: conn} do
      conn = get(conn, Routes.tracking_path(conn, :track, url_params: "?utm_source=shopback"))
      assert response(conn, 200)
      last_user_attribution = UserAttribution |> Repo.all() |> List.last()
      assert %UserAttribution{} = user_attribution = last_user_attribution
      assert not is_nil(user_attribution.user_cookie)

      conn = get(conn, Routes.tracking_path(conn, :track, user_id: 3))
      assert response(conn, 200)
      new_last_user_attribution = UserAttribution |> Repo.all() |> List.last()
      assert new_last_user_attribution.id == last_user_attribution.id
      assert not is_nil(new_last_user_attribution.user_id)
    end

    test "when user_attribution with a user_id exists, and a new request with the same user_id is made it shouldn't create a new attribution",
         %{conn: conn} do
      Attribution |> Repo.delete_all()
      assert Enum.count(Attributions.list_attributions()) == 0

      conn =
        get(conn, Routes.tracking_path(conn, :track, url_params: "?utm_source=shopback", user_id: 3))

      assert response(conn, 200)
      assert Enum.count(Attributions.list_attributions()) == 1
      last_attribution = Attribution |> Repo.all() |> List.last()
      assert last_attribution.user_id == 3

      conn = get(conn, Routes.tracking_path(conn, :track, user_id: 3))
      assert response(conn, 200)
      assert Enum.count(Attributions.list_attributions()) == 1
    end

    test "when user_attribution with a user_id exists, and a new request with an updated user_id is made it should create a new attribution",
         %{conn: conn} do
      Attribution |> Repo.delete_all()
      assert Enum.count(Attributions.list_attributions()) == 0

      conn =
        get(conn, Routes.tracking_path(conn, :track, url_params: "?utm_source=shopback", user_id: 3))

      assert response(conn, 200)
      assert Enum.count(Attributions.list_attributions()) == 1
      last_attribution = Attribution |> Repo.all() |> List.last()
      assert last_attribution.user_id == 3

      conn = get(conn, Routes.tracking_path(conn, :track, user_id: 4))
      assert response(conn, 200)
      assert Enum.count(Attributions.list_attributions()) == 2
    end

    test "when user_attribution with a user_id exists, and a new request with  the same user_id is made it shouldn't update the user_attribution" do
    end
  end
end

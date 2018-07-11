defmodule WebsFlyerWeb.API.MediaSourceControllerTest do
  use WebsFlyerWeb.ConnCase

  alias WebsFlyer.Affiliates
  alias WebsFlyer.Affiliates.MediaSource

  @create_attrs %{aff_name: "some aff_name", attribution_window_in_seconds: 42, do_postback: true, name: "some name"}
  @update_attrs %{aff_name: "some updated aff_name", attribution_window_in_seconds: 43, do_postback: false, name: "some updated name"}
  @invalid_attrs %{aff_name: nil, attribution_window_in_seconds: nil, do_postback: nil, name: nil}

  def fixture(:media_source) do
    {:ok, media_source} = Affiliates.create_media_source(@create_attrs)
    media_source
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all media_sources", %{conn: conn} do
      conn = get conn, api_media_source_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create media_source" do
    test "renders media_source when data is valid", %{conn: conn} do
      conn = post conn, api_media_source_path(conn, :create), media_source: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_media_source_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "aff_name" => "some aff_name",
        "attribution_window_in_seconds" => 42,
        "do_postback" => true,
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_media_source_path(conn, :create), media_source: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update media_source" do
    setup [:create_media_source]

    test "renders media_source when data is valid", %{conn: conn, media_source: %MediaSource{id: id} = media_source} do
      conn = put conn, api_media_source_path(conn, :update, media_source), media_source: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_media_source_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "aff_name" => "some updated aff_name",
        "attribution_window_in_seconds" => 43,
        "do_postback" => false,
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, media_source: media_source} do
      conn = put conn, api_media_source_path(conn, :update, media_source), media_source: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete media_source" do
    setup [:create_media_source]

    test "deletes chosen media_source", %{conn: conn, media_source: media_source} do
      conn = delete conn, api_media_source_path(conn, :delete, media_source)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_media_source_path(conn, :show, media_source)
      end
    end
  end

  defp create_media_source(_) do
    media_source = fixture(:media_source)
    {:ok, media_source: media_source}
  end
end

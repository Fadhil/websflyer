defmodule WebsFlyer.AffiliatesTest do
  use WebsFlyer.DataCase

  alias WebsFlyer.Affiliates
  alias WebsFlyer.Affiliates.Attribution

  doctest WebsFlyer.Affiliates

  describe "attributions" do

    @valid_attrs %{aff_name: "affiliate_name", event: "event_type", rs_id: 42, s2s_post_params: "some s2s_post_params", status: "some status", transaction_id: "some transaction_id", url_params: "?utm_source=affiliate_name&utm_medium=Affiliate", user_cookie: "randomusercookie", user_id: 42}
    @valid_click_attrs %{"url_params" => "?utm_source=affiliate_name&utm_medium=Affiliate", "user_cookie" => "randomusercookie", "user_id" => nil, "event" => "click"} 
    @invalid_attrs %{aff_name: nil, event: nil, rs_id: nil, s2s_post_params: nil, status: nil, transaction_id: nil, url_params: nil, user_cookie: nil, user_id: nil}

    def attribution_fixture(attrs \\ %{}) do
      {:ok, attribution} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Affiliates.create_attribution()

      attribution
    end

    test "list_attributions/0 returns all attributions" do
      attribution = attribution_fixture()
      assert Affiliates.list_attributions() == [attribution]
    end

    test "get_attribution!/1 returns the attribution with given id" do
      attribution = attribution_fixture()
      assert Affiliates.get_attribution!(attribution.id) == attribution
    end

    test "create_attribution/1 with valid click attribution data creates a click attribution" do
      assert {:ok, attribution = %Attribution{event: "click"}} = Affiliates.create_attribution(@valid_click_attrs)
      assert attribution.url_params == "?utm_source=affiliate_name&utm_medium=Affiliate"
      assert attribution.user_cookie == "randomusercookie"
      assert attribution.aff_name == "affiliate_name"
    end

    test "create_attribution/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Affiliates.create_attribution(@invalid_attrs)
    end

    test "create_attribution/1 with url_params, aff_name and user_cookie and event `click` attribution" do
      assert {:ok, %Attribution{} = _attribution} = Affiliates.create_attribution(@valid_click_attrs)
    end

    test "update_attribution/2 with invalid data returns error changeset" do
      attribution = attribution_fixture()
      assert {:error, %Ecto.Changeset{}} = Affiliates.update_attribution(attribution, @invalid_attrs)
      assert attribution == Affiliates.get_attribution!(attribution.id)
    end

    test "delete_attribution/1 deletes the attribution" do
      attribution = attribution_fixture()
      assert {:ok, %Attribution{}} = Affiliates.delete_attribution(attribution)
      assert_raise Ecto.NoResultsError, fn -> Affiliates.get_attribution!(attribution.id) end
    end

    test "change_attribution/1 returns a attribution changeset" do
      attribution = attribution_fixture()
      assert %Ecto.Changeset{} = Affiliates.change_attribution(attribution)
    end
  end

  describe "media_sources" do
    alias WebsFlyer.Affiliates.MediaSource

    @valid_attrs %{aff_name: "some aff_name", attribution_window_in_seconds: 42, do_postback: true, name: "some name"}
    @update_attrs %{aff_name: "some updated aff_name", attribution_window_in_seconds: 43, do_postback: false, name: "some updated name"}
    @invalid_attrs %{aff_name: nil, attribution_window_in_seconds: nil, do_postback: nil, name: nil}

    def media_source_fixture(attrs \\ %{}) do
      {:ok, media_source} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Affiliates.create_media_source()

      media_source
    end

    test "list_media_sources/0 returns all media_sources" do
      media_source = media_source_fixture()
      assert Affiliates.list_media_sources() == [media_source]
    end

    test "get_media_source!/1 returns the media_source with given id" do
      media_source = media_source_fixture()
      assert Affiliates.get_media_source!(media_source.id) == media_source
    end

    test "create_media_source/1 with valid data creates a media_source" do
      assert {:ok, %MediaSource{} = media_source} = Affiliates.create_media_source(@valid_attrs)
      assert media_source.aff_name == "some aff_name"
      assert media_source.attribution_window_in_seconds == 42
      assert media_source.do_postback == true
      assert media_source.name == "some name"
    end

    test "create_media_source/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Affiliates.create_media_source(@invalid_attrs)
    end

    test "update_media_source/2 with valid data updates the media_source" do
      media_source = media_source_fixture()
      assert {:ok, media_source} = Affiliates.update_media_source(media_source, @update_attrs)
      assert %MediaSource{} = media_source
      assert media_source.aff_name == "some updated aff_name"
      assert media_source.attribution_window_in_seconds == 43
      assert media_source.do_postback == false
      assert media_source.name == "some updated name"
    end

    test "update_media_source/2 with invalid data returns error changeset" do
      media_source = media_source_fixture()
      assert {:error, %Ecto.Changeset{}} = Affiliates.update_media_source(media_source, @invalid_attrs)
      assert media_source == Affiliates.get_media_source!(media_source.id)
    end

    test "delete_media_source/1 deletes the media_source" do
      media_source = media_source_fixture()
      assert {:ok, %MediaSource{}} = Affiliates.delete_media_source(media_source)
      assert_raise Ecto.NoResultsError, fn -> Affiliates.get_media_source!(media_source.id) end
    end

    test "change_media_source/1 returns a media_source changeset" do
      media_source = media_source_fixture()
      assert %Ecto.Changeset{} = Affiliates.change_media_source(media_source)
    end
  end
end

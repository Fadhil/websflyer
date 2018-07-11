defmodule WebsFlyer.AffiliatesTest do
  use WebsFlyer.DataCase

  alias WebsFlyer.Affiliates
  alias WebsFlyer.Affiliates.Attribution

  doctest WebsFlyer.Affiliates

  describe "attributions" do

    @valid_attrs %{aff_name: "affiliate_name", event: "event_type", rs_id: 3600, s2s_post_params: "some s2s_post_params", status: "some status", transaction_id: "some transaction_id", url_params: "?utm_source=affiliate_name&utm_medium=Affiliate", user_cookie: "randomusercookie", user_id: 3600}
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

    @valid_ms_attrs %{aff_name: "affiliate_1", attribution_window_in_seconds: 3600, do_postback: true, name: "some name"}
    @valid_ms_attrs_dup_aff_name %{aff_name: "affiliate_1", attribution_window_in_seconds: 18400, do_postback: true, name: "some other name"}
    @valid_ms_attrs_without_attribution_window %{aff_name: "affiliate_no_attribution"}
    @update_attrs %{aff_name: "some updated aff_name", attribution_window_in_seconds: 7200, do_postback: false, name: "some updated name"}
    @invalid_ms_attrs %{aff_name: nil}

    def media_source_fixture(attrs \\ %{}) do
      {:ok, media_source} =
        attrs
        |> Enum.into(@valid_ms_attrs)
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
      assert {:ok, %MediaSource{} = media_source} = Affiliates.create_media_source(@valid_ms_attrs)
      assert media_source.aff_name == "affiliate_1"
      assert media_source.attribution_window_in_seconds == 3600
      assert media_source.do_postback == true
      assert media_source.name == "some name"
    end

    test "create_media_source/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Affiliates.create_media_source(@invalid_ms_attrs)
    end

    test "update_media_source/2 with valid data updates the media_source" do
      media_source = media_source_fixture()
      assert {:ok, media_source} = Affiliates.update_media_source(media_source, @update_attrs)
      assert %MediaSource{} = media_source
      assert media_source.aff_name == "some updated aff_name"
      assert media_source.attribution_window_in_seconds == 7200
      assert media_source.do_postback == false
      assert media_source.name == "some updated name"
    end

    test "update_media_source/2 with invalid data returns error changeset" do
      media_source = media_source_fixture()
      assert {:error, %Ecto.Changeset{}} = Affiliates.update_media_source(media_source, @invalid_ms_attrs)
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

    test "get_media_source_by_name/1 returns a media_source" do
      media_source = media_source_fixture()
      assert media_source == Affiliates.get_media_source_by_name("affiliate_1")
    end

    test "get_media_source_by_name/1 returns the latest media_source when multiple rows with same name exist" do
      _media_source = media_source_fixture()
      media_source2 = media_source_fixture(@valid_ms_attrs_dup_aff_name)
      assert media_source2 == Affiliates.get_media_source_by_name("affiliate_1")
    end

    test "get_media_source_by_name/1 returns nil when media_source does not exist" do
      assert nil == Affiliates.get_media_source_by_name("non_existent_media_source")
    end
  end

  describe "get_attribution_window/1" do
    alias WebsFlyer.Affiliates.MediaSource

    test "returns a media_source.attribution_window_in_seconds if media_source with given aff_name exists" do
      _media_source1 = media_source_fixture()
      assert 3600 = Affiliates.get_attribution_window("affiliate_1")
    end

    test "returns a default attribution of 24 hours if media_source with given aff_name does not exist" do
      assert 86400 = Affiliates.get_attribution_window("non_existent_affiliate")
    end

    test "returns a default attribution window of 24 hours if media_source doesn't have attribution_window_in_seconds" do
      _media_source = Affiliates.create_media_source(@valid_ms_attrs_without_attribution_window)
      assert 86400 = Affiliates.get_attribution_window("affiliate_no_attribution")
    end
  end
end

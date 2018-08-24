defmodule Websflyer.Affiliates.MediaSources.MediaSourcesTest do
  use Websflyer.DataCase

  alias Websflyer.Affiliates

  doctest Websflyer.Affiliates
  alias Websflyer.Affiliates.Schemas.MediaSource

  describe "media_sources" do
    @valid_ms_attrs %{
      aff_name: "affiliate_1",
      attribution_window_in_seconds: 3600,
      do_postback: true,
      name: "some name"
    }
    @valid_ms_attrs_dup_aff_name %{
      aff_name: "affiliate_1",
      attribution_window_in_seconds: 18400,
      do_postback: true,
      name: "some other name"
    }
    @valid_ms_attrs_without_attribution_window %{aff_name: "affiliate_no_attribution"}
    @update_attrs %{
      aff_name: "some updated aff_name",
      attribution_window_in_seconds: 7200,
      do_postback: false,
      name: "some updated name"
    }
    @invalid_ms_attrs %{aff_name: nil}

    def media_source_fixture(attrs \\ %{}) do
      {:ok, media_source} =
        attrs
        |> Enum.into(@valid_ms_attrs)
        |> Affiliates.MediaSources.create_media_source()

      media_source
    end

    test "list_media_sources/0 returns all media_sources" do
      media_source = media_source_fixture()
      assert Affiliates.MediaSources.list_media_sources() == [media_source]
    end

    test "get_media_source!/1 returns the media_source with given id" do
      media_source = media_source_fixture()
      assert Affiliates.MediaSources.get_media_source!(media_source.id) == media_source
    end

    test "create_media_source/1 with valid data creates a media_source" do
      assert {:ok, %MediaSource{} = media_source} =
               Affiliates.MediaSources.create_media_source(@valid_ms_attrs)

      assert media_source.aff_name == "affiliate_1"
      assert media_source.attribution_window_in_seconds == 3600
      assert media_source.do_postback == true
      assert media_source.name == "some name"
    end

    test "create_media_source/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Affiliates.MediaSources.create_media_source(@invalid_ms_attrs)
    end

    test "update_media_source/2 with valid data updates the media_source" do
      media_source = media_source_fixture()

      assert {:ok, media_source} =
               Affiliates.MediaSources.update_media_source(media_source, @update_attrs)

      assert %MediaSource{} = media_source
      assert media_source.aff_name == "some updated aff_name"
      assert media_source.attribution_window_in_seconds == 7200
      assert media_source.do_postback == false
      assert media_source.name == "some updated name"
    end

    test "update_media_source/2 with invalid data returns error changeset" do
      media_source = media_source_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Affiliates.MediaSources.update_media_source(media_source, @invalid_ms_attrs)

      assert media_source == Affiliates.MediaSources.get_media_source!(media_source.id)
    end

    test "delete_media_source/1 deletes the media_source" do
      media_source = media_source_fixture()
      assert {:ok, %MediaSource{}} = Affiliates.MediaSources.delete_media_source(media_source)

      assert_raise Ecto.NoResultsError, fn ->
        Affiliates.MediaSources.get_media_source!(media_source.id)
      end
    end

    test "change_media_source/1 returns a media_source changeset" do
      media_source = media_source_fixture()
      assert %Ecto.Changeset{} = Affiliates.MediaSources.change_media_source(media_source)
    end

    test "get_media_source_by_name/1 returns a media_source" do
      media_source = media_source_fixture()
      assert media_source == Affiliates.MediaSources.get_media_source_by_name("affiliate_1")
    end

    test "get_media_source_by_name/1 returns the latest media_source when multiple rows with same name exist" do
      _media_source = media_source_fixture()
      media_source2 = media_source_fixture(@valid_ms_attrs_dup_aff_name)
      assert media_source2 == Affiliates.MediaSources.get_media_source_by_name("affiliate_1")
    end

    test "get_media_source_by_name/1 returns nil when media_source does not exist" do
      assert nil == Affiliates.MediaSources.get_media_source_by_name("non_existent_media_source")
    end
  end

  describe "get_attribution_window/1" do
    test "returns a media_source.attribution_window_in_seconds if media_source with given aff_name exists" do
      _media_source1 = media_source_fixture()
      assert 3600 = Affiliates.MediaSources.get_attribution_window("affiliate_1")
    end

    test "returns a default attribution of 30 days if media_source with given aff_name does not exist" do
      assert 2_592_000 = Affiliates.MediaSources.get_attribution_window("non_existent_affiliate")
    end

    test "returns a default attribution window of 30 days hours if media_source doesn't have attribution_window_in_seconds" do
      _media_source =
        Affiliates.MediaSources.create_media_source(@valid_ms_attrs_without_attribution_window)

      assert 2_592_000 =
               Affiliates.MediaSources.get_attribution_window("affiliate_no_attribution")
    end
  end
end

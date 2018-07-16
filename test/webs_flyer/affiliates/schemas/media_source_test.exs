defmodule WebsFlyer.Affiliates.Schemas.MediaSourceTest do
  use WebsFlyer.DataCase

  alias WebsFlyer.Affiliates.Schemas.MediaSource

  @valid_media_source_attrs %{"aff_name" => "some_aff_name"}
  @invalid_media_source_attrs %{}

  test "media_source with valid click attributions (has aff_name)" do
    changset = MediaSource.changeset(%MediaSource{}, @valid_media_source_attrs)
    assert changset.valid?
  end

  test "media_source with invalid click attributions (does not have aff_name)" do
    changset = MediaSource.changeset(%MediaSource{}, @invalid_media_source_attrs)
    refute changset.valid?
  end
end
defmodule WebsFlyer.Affiliates.AttributionTest do
  use WebsFlyer.DataCase

  alias WebsFlyer.Affiliates.Attribution

  @valid_click_attributes %{event: "click", url_params: "?utm_source=affiliate_name", user_cookie: "randomusercookie"}
  @invalid_click_attributes %{url_params: "?utm_source=affiliate_name", user_cookie: "randomusercookie"}

  test "click_changeset with valid click attributions" do
    changeset = Attribution.click_changeset(%Attribution{}, @valid_click_attributes)
    assert changeset.valid?
  end

  test "click_changeset without event" do
    changeset = Attribution.click_changeset(%Attribution{}, @invalid_click_attributes)
    refute changeset.valid?
  end
end
defmodule WebsFlyer.Affiliates.AttributionTest do
  use WebsFlyer.DataCase

  alias WebsFlyer.Affiliates.Attribution

  @valid_click_attributes %{event: "click", url_params: "?utm_source=affiliate_name", user_cookie: "randomusercookie"}
  @invalid_click_attributes %{url_params: "?utm_source=affiliate_name", user_cookie: "randomusercookie"}
  @valid_login_attributes %{event: "login", user_id: 3, user_cookie: "randomusercookie"}
  @invalid_login_attributes %{event: "login"}

  test "changeset with valid click attributions is valid" do
    changeset = Attribution.changeset(%Attribution{}, @valid_click_attributes)
    assert changeset.valid?
  end

  test "changeset without event is not valid" do
    changeset = Attribution.changeset(%Attribution{}, @invalid_click_attributes)
    refute changeset.valid?
  end

  test "changeset with valid login data (has user_id, user_cookie and event = login) is valid" do
    changeset = Attribution.changeset(%Attribution{}, @valid_login_attributes)
    assert changeset.valid?
  end

  test "changeset with invalid login data (no user_id or user_cookie) is invalid" do
    changeset = Attribution.changeset(%Attribution{}, @invalid_login_attributes)
    assert changeset.valid?
  end
end
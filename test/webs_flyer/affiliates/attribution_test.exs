defmodule WebsFlyer.Affiliates.AttributionTest do
  use WebsFlyer.DataCase

  alias WebsFlyer.Affiliates.Attribution

  @valid_click_attributes %{"event" => "click", "url_params" => "?utm_source=affiliate_name", "user_cookie" => "randomusercookie"}
  @invalid_click_attributes %{"event" => "click"}
  @invalid_event_attributes %{"url_params" => "?utm_source=affiliate", "user_cookie" => "somerandomcookie"}
  @valid_login_attributes %{"event" => "login", "user_id" => 3, "user_cookie" => "randomusercookie"}
  @invalid_login_attributes %{"event" => "login"}
  @valid_transaction_attributes %{"event" => "transaction", "user_id" => 3, "rs_id" => 1234}
  @invalid_transaction_attributes %{"event" => "transaction"}

  test "changeset with valid click attributions is valid" do
    changeset = Attribution.changeset(%Attribution{}, @valid_click_attributes)
    assert changeset.valid?
  end

  test "changeset without event is not valid" do
    changeset = Attribution.changeset(%Attribution{}, @invalid_event_attributes)
    refute changeset.valid?
  end

  test "changeset with valid login data (has user_id, user_cookie and event = login) is valid" do
    changeset = Attribution.changeset(%Attribution{}, @valid_login_attributes)
    assert changeset.valid?
  end

  test "changeset with invalid login data (no user_id or user_cookie) is invalid" do
    changeset = Attribution.changeset(%Attribution{}, @invalid_login_attributes)
    refute changeset.valid?
  end

  test "changeset with valid transaction data (has rs_id, user_id, event = transaction) is valid" do
    changeset = Attribution.changeset(%Attribution{}, @valid_transaction_attributes)
    assert changeset.valid?
  end 

  test "changeset with invalid transaction data (event = transaction, does not have rs_id or user_id) is invalid" do
    changeset = Attribution.changeset(%Attribution{}, @invalid_transaction_attributes)
    refute changeset.valid?
  end 
end
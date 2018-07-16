defmodule WebsFlyer.Affiliates.UserAttributionsTest do
  use WebsFlyer.DataCase

  alias WebsFlyer.Affiliates
  alias WebsFlyer.Affiliates.Schemas.UserAttribution
  describe "user_attributions" do

    @valid_attrs %{attributed_to: "affiliate_name", attribution_start_timestamp: 42, attribution_window_in_seconds: 42, user_cookie: "randomusercookie", user_id: 42}
    @update_attrs %{attributed_to: "update_affiliate_name", attribution_start_timestamp: 43, attribution_window_in_seconds: 43, user_cookie: "update_randomusercookie", user_id: 43}
    @invalid_attrs %{attributed_to: nil, attribution_start_timestamp: nil, attribution_window_in_seconds: nil, user_cookie: nil, user_id: nil}

    def user_attribution_fixture(attrs \\ %{}) do
      {:ok, user_attribution} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Affiliates.UserAttributions.create_user_attribution()

      user_attribution
    end

    test "list_user_attributions/0 returns all user_attributions" do
      user_attribution = user_attribution_fixture()
      assert Affiliates.UserAttributions.list_user_attributions() == [user_attribution]
    end

    test "get_user_attribution!/1 returns the user_attribution with given id" do
      user_attribution = user_attribution_fixture()
      assert Affiliates.UserAttributions.get_user_attribution!(user_attribution.id) == user_attribution
    end

    test "get_by_user_cookie/1 returns the user_attribution with given user_cookie" do
      user_attribution = user_attribution_fixture()
    end

    test "create_user_attribution/1 with valid data creates a user_attribution" do
      assert {:ok, %UserAttribution{} = user_attribution} = Affiliates.UserAttributions.create_user_attribution(@valid_attrs)
      assert user_attribution.attributed_to == "affiliate_name"
      assert user_attribution.attribution_start_timestamp == 42
      assert user_attribution.attribution_window_in_seconds == 42
      assert user_attribution.user_cookie == "randomusercookie"
      assert user_attribution.user_id == 42
    end

    test "create_user_attribution/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Affiliates.UserAttributions.create_user_attribution(@invalid_attrs)
    end

    test "update_user_attribution/2 with valid data updates the user_attribution" do
      user_attribution = user_attribution_fixture()
      assert {:ok, user_attribution} = Affiliates.UserAttributions.update_user_attribution(user_attribution, @update_attrs)
      assert %UserAttribution{} = user_attribution
      assert user_attribution.attributed_to == "update_affiliate_name"
      assert user_attribution.attribution_start_timestamp == 43
      assert user_attribution.attribution_window_in_seconds == 43
      assert user_attribution.user_cookie == "update_randomusercookie"
      assert user_attribution.user_id == 43
    end

    test "update_user_attribution/2 with invalid data returns error changeset" do
      user_attribution = user_attribution_fixture()
      assert {:error, %Ecto.Changeset{}} = Affiliates.UserAttributions.update_user_attribution(user_attribution, @invalid_attrs)
      assert user_attribution == Affiliates.UserAttributions.get_user_attribution!(user_attribution.id)
    end

    test "delete_user_attribution/1 deletes the user_attribution" do
      user_attribution = user_attribution_fixture()
      assert {:ok, %UserAttribution{}} = Affiliates.UserAttributions.delete_user_attribution(user_attribution)
      assert_raise Ecto.NoResultsError, fn -> Affiliates.UserAttributions.get_user_attribution!(user_attribution.id) end
    end

    test "change_user_attribution/1 returns a user_attribution changeset" do
      user_attribution = user_attribution_fixture()
      assert %Ecto.Changeset{} = Affiliates.UserAttributions.change_user_attribution(user_attribution)
    end
  end
end
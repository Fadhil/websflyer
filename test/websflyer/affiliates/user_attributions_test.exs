defmodule Websflyer.Affiliates.UserAttributionsTest do
  use Websflyer.DataCase

  alias Websflyer.Affiliates
  alias Websflyer.TestData
  alias Affiliates.{Attributions, UserAttributions}
  alias Websflyer.Affiliates.Schemas.UserAttribution

  describe "user_attributions" do
    @valid_attrs %{
      attributed_to: "affiliate_name",
      attribution_start_timestamp: 42,
      attribution_window_in_seconds: 42,
      user_cookie: "randomusercookie",
      user_id: 42
    }
    @update_attrs %{
      attributed_to: "update_affiliate_name",
      attribution_start_timestamp: 43,
      attribution_window_in_seconds: 43,
      user_cookie: "update_randomusercookie",
      user_id: 43
    }
    @invalid_attrs %{
      attributed_to: nil,
      attribution_start_timestamp: nil,
      attribution_window_in_seconds: nil,
      user_cookie: nil,
      user_id: nil
    }

    def user_attribution_fixture(attrs \\ %{}) do
      {:ok, user_attribution} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserAttributions.create_user_attribution()

      user_attribution
    end

    test "list_user_attributions/0 returns all user_attributions" do
      user_attribution = user_attribution_fixture()
      assert UserAttributions.list_user_attributions() == [user_attribution]
    end

    test "get_user_attribution!/1 returns the user_attribution with given id" do
      user_attribution = user_attribution_fixture()
      assert UserAttributions.get_user_attribution!(user_attribution.id) == user_attribution
    end

    test "get_by_user_cookie/1 returns the user_attribution with given user_cookie" do
      user_attribution = user_attribution_fixture()
      assert user_attribution == UserAttributions.get_by_user_cookie("randomusercookie")
    end

    test "get_by_user_id/1 returns the latest user_attribution with the given user_id" do
      user_attribution = user_attribution_fixture()
      assert user_attribution == UserAttributions.get_by_user_id(42)
    end

    test "create_user_attribution/1 with valid data creates a user_attribution" do
      assert {:ok, %UserAttribution{} = user_attribution} =
               UserAttributions.create_user_attribution(@valid_attrs)

      assert user_attribution.attributed_to == "affiliate_name"
      assert user_attribution.attribution_start_timestamp == 42
      assert user_attribution.attribution_window_in_seconds == 42
      assert user_attribution.user_cookie == "randomusercookie"
      assert user_attribution.user_id == 42
    end

    test "create_user_attribution/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               UserAttributions.create_user_attribution(@invalid_attrs)
    end

    test "update_user_attribution/2 with valid data updates the user_attribution" do
      user_attribution = user_attribution_fixture()

      assert {:ok, user_attribution} =
               UserAttributions.update_user_attribution(user_attribution, @update_attrs)

      assert %UserAttribution{} = user_attribution
      assert user_attribution.attributed_to == "update_affiliate_name"
      assert user_attribution.attribution_start_timestamp == 43
      assert user_attribution.attribution_window_in_seconds == 43
      assert user_attribution.user_cookie == "update_randomusercookie"
      assert user_attribution.user_id == 43
    end

    test "update_user_attribution/2 with invalid data returns error changeset" do
      user_attribution = user_attribution_fixture()

      assert {:error, %Ecto.Changeset{}} =
               UserAttributions.update_user_attribution(user_attribution, @invalid_attrs)

      assert user_attribution == UserAttributions.get_user_attribution!(user_attribution.id)
    end

    test "delete_user_attribution/1 deletes the user_attribution" do
      user_attribution = user_attribution_fixture()

      assert {:ok, %UserAttribution{}} =
               UserAttributions.delete_user_attribution(user_attribution)

      assert_raise Ecto.NoResultsError, fn ->
        UserAttributions.get_user_attribution!(user_attribution.id)
      end
    end

    test "change_user_attribution/1 returns a user_attribution changeset" do
      user_attribution = user_attribution_fixture()
      assert %Ecto.Changeset{} = UserAttributions.change_user_attribution(user_attribution)
    end

    test "within_attribution_window/2 returns true if a given timestamp is within a user_attributions window" do
      {:ok, user_attribution} =
        UserAttributions.create_user_attribution(TestData.click_now_user_attribution())

      assert UserAttributions.within_attribution_window(
               user_attribution,
               Attributions.timestamp_now()
             ) == true
    end

    test "within_attribution_window/2 returns false if a given timestamp not within a user_attributions window" do
      {:ok, user_attribution} =
        UserAttributions.create_user_attribution(TestData.click_25hrs_ago_user_attribution())

      assert UserAttributions.within_attribution_window(
               user_attribution,
               Attributions.timestamp_now()
             ) == false
    end
  end
end

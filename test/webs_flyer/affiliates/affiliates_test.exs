defmodule WebsFlyer.AffiliatesTest do
  use WebsFlyer.DataCase

  alias WebsFlyer.Affiliates
  alias WebsFlyer.Affiliates.Attribution

  doctest WebsFlyer.Affiliates

  describe "attributions" do

    @valid_attrs %{aff_name: "affiliate_name", event: "event_type", rs_id: 42, s2s_post_params: "some s2s_post_params", status: "some status", transaction_id: "some transaction_id", url_params: "?utm_source=affiliate_name&utm_medium=Affiliate", user_cookie: "randomusercookie", user_id: 42}
    @valid_click_attrs %{url_params: "param1=test1&param2=test2", user_cookie: "randomusercookie", user_id: nil} 
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

    test "create_attribution/1 with valid data creates a attribution" do
      assert {:ok, %Attribution{} = attribution} = Affiliates.create_attribution(@valid_attrs)
      assert attribution.url_params == "?utm_source=affiliate_name&utm_medium=Affiliate"
      assert attribution.user_cookie == "randomusercookie"
    end

    test "create_attribution/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Affiliates.create_attribution(@invalid_attrs)
    end

    test "create_attribution/1 with url_params, aff_name and user_cookie creates a `click` attribution" do
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
end

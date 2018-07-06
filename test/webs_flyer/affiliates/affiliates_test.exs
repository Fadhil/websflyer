defmodule WebsFlyer.AffiliatesTest do
  use WebsFlyer.DataCase

  alias WebsFlyer.Affiliates

  describe "attributions" do
    alias WebsFlyer.Affiliates.Attribution

    @valid_attrs %{aff_name: "some aff_name", event: "some event", rs_id: 42, s2s_post_params: "some s2s_post_params", status: "some status", transaction_id: "some transaction_id", url_params: "some url_params", user_cookie: "some user_cookie", user_id: 42}
    @update_attrs %{aff_name: "some updated aff_name", event: "some updated event", rs_id: 43, s2s_post_params: "some updated s2s_post_params", status: "some updated status", transaction_id: "some updated transaction_id", url_params: "some updated url_params", user_cookie: "some updated user_cookie", user_id: 43}
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
      assert attribution.aff_name == "some aff_name"
      assert attribution.event == "some event"
      assert attribution.rs_id == 42
      assert attribution.s2s_post_params == "some s2s_post_params"
      assert attribution.status == "some status"
      assert attribution.transaction_id == "some transaction_id"
      assert attribution.url_params == "some url_params"
      assert attribution.user_cookie == "some user_cookie"
      assert attribution.user_id == 42
    end

    test "create_attribution/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Affiliates.create_attribution(@invalid_attrs)
    end

    test "update_attribution/2 with valid data updates the attribution" do
      attribution = attribution_fixture()
      assert {:ok, attribution} = Affiliates.update_attribution(attribution, @update_attrs)
      assert %Attribution{} = attribution
      assert attribution.aff_name == "some updated aff_name"
      assert attribution.event == "some updated event"
      assert attribution.rs_id == 43
      assert attribution.s2s_post_params == "some updated s2s_post_params"
      assert attribution.status == "some updated status"
      assert attribution.transaction_id == "some updated transaction_id"
      assert attribution.url_params == "some updated url_params"
      assert attribution.user_cookie == "some updated user_cookie"
      assert attribution.user_id == 43
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

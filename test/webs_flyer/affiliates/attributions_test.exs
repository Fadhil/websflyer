defmodule WebsFlyer.Affiliates.Schemas.AttributionsTest do
  use WebsFlyer.DataCase

  alias WebsFlyer.Affiliates.Schemas.{Attribution, UserAttribution}
  alias WebsFlyer.Affiliates.{Attributions, MediaSources}
  alias WebsFlyer.TestData
  describe "attributions" do

    @valid_attrs %{event: "click", url_params: "?utm_source=shopback&utm_medium=Affiliate", user_cookie: "randomusercookie"}
    @valid_click_attrs %{"url_params" => "?utm_source=affiliate_name&utm_medium=Affiliate", "user_cookie" => "randomusercookie", "user_id" => nil, "event" => "click"} 
    @valid_login_attrs %{"user_cookie" => "randomusercookie", "user_id" => 4, "event" => "login"} 
    @invalid_login_without_user_cookie_attrs %{"event" => "login", "user_cookie" => "randomusercookie"}
    @invalid_login_without_user_id_attrs %{"event" => "login", "user_cookie" => "randomusercookie"}
    @invalid_attrs %{aff_name: nil, event: nil, rs_id: nil, s2s_post_params: nil, status: nil, transaction_id: nil, url_params: nil, user_cookie: nil, user_id: nil}
    @valid_media_source TestData.valid_media_source_attrs
    def attribution_fixture(attrs \\ %{}) do
      {:ok, attribution} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Attributions.create_attribution()

      attribution
    end

    test "list_attributions/0 returns all attributions" do
      attribution = attribution_fixture()
      assert Attributions.list_attributions() == [attribution]
    end

    test "get_attribution!/1 returns the attribution with given id" do
      attribution = attribution_fixture()
      assert Attributions.get_attribution!(attribution.id) == attribution
    end

    test "get_attribution/1 with a user_cookie returns the last attribution with that cookie" do
      attribution = attribution_fixture()
      assert Attributions.get_attribution("randomusercookie") == attribution
    end

    test "create_attribution/1 with valid click attribution data creates a click attribution" do
      assert {:ok, media_source} = MediaSources.create_media_source(@valid_media_source)
      assert {:ok, [attribution, user_attribution] = [%Attribution{event: "click"}, %{}]} = Attributions.create_attribution(@valid_click_attrs)
 
      assert attribution.url_params() == "?utm_source=affiliate_name&utm_medium=Affiliate"
      assert attribution.user_cookie() == "randomusercookie"
      assert attribution.aff_name() == "affiliate_name"
    end

    # test "create_attribution/1 with valid click attribution data also creates a user_attribution entry" do
    #   assert {:ok, attribution = %Attribution{event: "click"}} = Attributions.create_attribution(@valid_click_attrs)
    #   assert {:ok, [user_attribution|_] = [%UserAttribution{user_cookie: "randomusercookie"}|tail]} = Attributions.get_user_attributions(attribution.user_cookie)
    # end

    test "create_attribution/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Attributions.create_attribution(@invalid_attrs)
    end

    test "create_attribution/1 with url_params, aff_name and user_cookie and event `click` attribution" do
      assert {:ok, [%Attribution{}, %UserAttribution{}] = [attribution, user_attribution]} = Attributions.create_attribution(@valid_click_attrs)
      assert "click" = attribution.event
    end

    test "create_attribution/1 with user_id, url_params and event `login` and user_cookie creates a `login` attribution" do
      assert {:ok, %Attribution{} = attribution} = Attributions.create_attribution(@valid_login_attrs)
      assert "login" = attribution.event
    end

    test "create_attribution/1 with event `login` without a user_id returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Attributions.create_attribution(@invalid_login_without_user_id_attrs)
    end
    
    test "create_attribution/1 with event `login` without a user_cookie returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Attributions.create_attribution(@invalid_login_without_user_cookie_attrs)
    end

    test "update_attribution/2 with invalid data returns error changeset" do
      attribution = attribution_fixture()
      assert {:error, %Ecto.Changeset{}} = Attributions.update_attribution(attribution, @invalid_attrs)
      assert attribution == Attributions.get_attribution!(attribution.id)
    end

    test "delete_attribution/1 deletes the attribution" do
      attribution = attribution_fixture()
      assert {:ok, %Attribution{}} = Attributions.delete_attribution(attribution)
      assert_raise Ecto.NoResultsError, fn -> Attributions.get_attribution!(attribution.id) end
    end

    test "change_attribution/1 returns a attribution changeset" do
      attribution = attribution_fixture()
      assert %Ecto.Changeset{} = Attributions.change_attribution(attribution)
    end
  end

end
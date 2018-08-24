defmodule Websflyer.TestData do
  def anonymous_click_attrs do
    %{
      "url_params" => "?utm_source=some_affiliate",
      "user_cookie" => "randomcookie",
      "event" => "click"
    }
  end

  def invalid_click_attrs do
    %{
      "url_params" => "?utm_source=some_affiliate",
      "user_cookie" => nil,
      "event" => "click"
    }
  end

  def invalid_click_attrs2 do
    %{
      "url_params" => nil,
      "user_cookie" => "somerandomusercookie",
      "event" => "click"
    }
  end

  def valid_login_attrs do
    %{
      "event" => "login",
      "user_id" => 3,
      "user_cookie" => "randomusercookie"
    }
  end

  def invalid_login_without_user_id_attrs do
    %{
      "event" => "login",
      "user_cookie" => "randomusercookie"
    }
  end

  def invalid_login_without_user_cookie_attrs do
    %{
      "event" => "login",
      "user_id" => 3
    }
  end

  def valid_transaction_attrs do
    %{
      "event" => "transaction",
      "user_id" => 3,
      "rs_id" => 1234
    }
  end

  def invalid_transaction_without_user_id_attrs do
    %{
      "event" => "transaction",
      "rs_id" => 1234
    }
  end

  def invalid_transaction_without_rs_id_attrs do
    %{
      "event" => "transaction",
      "user_id" => 3
    }
  end

  def create_attrs do
    %{
      "aff_name" => "some aff_name",
      "event" => "click",
      "rs_id" => 42,
      "s2s_post_params" => "some s2s_post_params",
      "status" => "some status",
      "transaction_id" => "some transaction_id",
      "url_params" => "param1=test1&param2=test2",
      "user_cookie" => "randomusercookie",
      "user_id" => 42
    }
  end

  def update_attrs do
    %{
      "aff_name" => "some updated aff_name",
      "event" => "click",
      "rs_id" => 43,
      "s2s_post_params" => "some updated s2s_post_params",
      "status" => "some updated status",
      "transaction_id" => "some updated transaction_id",
      "url_params" => "some updated url_params",
      "user_cookie" => "randomusercookie",
      "user_id" => 43
    }
  end

  def invalid_attrs do
    %{
      "aff_name" => nil,
      "event" => nil,
      "rs_id" => nil,
      "s2s_post_params" => nil,
      "status" => nil,
      "transaction_id" => nil,
      "url_params" => nil,
      "user_cookie" => nil,
      "user_id" => nil
    }
  end

  def valid_media_source_attrs do
    %{
      aff_name: "some aff_name",
      attribution_window_in_seconds: 42,
      do_postback: true,
      name: "some name"
    }
  end

  def valid_media_source_update_attrs do
    %{
      aff_name: "some updated aff_name",
      attribution_window_in_seconds: 43,
      do_postback: false,
      name: "some updated name"
    }
  end

  def invalid_media_source_attrs do
    %{aff_name: nil, attribution_window_in_seconds: nil, do_postback: nil, name: nil}
  end

  def shopback_media_source do
    %{
      "aff_name" => "shopback",
      "name" => "Shopback People",
      "attribution_window_in_seconds" => 24 * 60 * 60
    }
  end

  def carousell_media_source do
    %{
      "aff_name" => "carousell",
      "name" => "Carousell People",
      "attribution_window_in_seconds" => 48 * 60 * 60
    }
  end

  def click_shopback_attrs do
    %{
      "event" => "click",
      "url_params" => "?utm_source=shopback&utm_medium=Affiliate",
      "user_cookie" => "random1234usercookie"
    }
  end

  def click_carousell_attrs do
    %{
      "event" => "click",
      "url_params" => "?utm_source=carousell&utm_medium=Affiliate",
      "user_cookie" => "random1234usercookie"
    }
  end

  def login_user_1234_attrs do
    %{
      "event" => "login",
      "user_cookie" => "random1234usercookie",
      "user_id" => 1234
    }
  end

  def login_attrs do
    %{
      "event" => "login",
      "user_id" => 3,
      "user_cookie" => "random1234usercookie"
    }
  end

  def transaction_user_1234_attrs do
    %{
      "event" => "transaction",
      "user_id" => 1234,
      "rs_id" => 5678
    }
  end

  def click_now_user_attribution do
    %{
      "user_cookie" => "randome_user_cookie",
      "attributed_to" => "shopback",
      "attribution_start_timestamp" =>
        DateTime.to_unix(DateTime.from_naive!(NaiveDateTime.utc_now(), "Etc/UTC")),
      "attribution_window_in_seconds" => 86400
    }
  end

  def click_25hrs_ago_user_attribution do
    %{
      "user_cookie" => "random_user_cookie",
      "attributed_to" => "shopback",
      "attribution_start_timestamp" =>
        DateTime.to_unix(DateTime.from_naive!(NaiveDateTime.utc_now(), "Etc/UTC")) - 90000,
      "attribution_window_in_seconds" => 86400
    }
  end
end

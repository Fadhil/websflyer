defmodule WebsFlyerWeb.TrackingController do
  use WebsFlyerWeb, :controller

  alias WebsFlyer.Affiliates.Attributions

  plug :serialize_url_params

  @invisible_pixel Base.decode64!("R0lGODlhAQABAIAAAP///wAAACwAAAAAAQABAAACAkQBADs=")

  def track(conn, _params) do
    conn
    |> track()
    |> put_resp_header("content-disposition", "inline")
    |> put_resp_content_type("image/gif")
    |> send_resp(200, @invisible_pixel)
  end

  def tracker(conn, _params) do
    render(conn, "tracker.js")
  end

  defp track(conn) do
    if should_track?(conn) do
      conn
      |> set_tracking_code()
      |> update_attribution()
    else
      conn
    end
  end

  defp set_tracking_code(conn) do
    user_cookie = Map.get(conn.cookies, "_websflyer_id")

    if is_nil(user_cookie) do
      put_resp_cookie(conn, "_websflyer_id", Phoenix.Token.sign(conn, "affiliate salt", System.system_time()))
    else
      conn
    end
  end

  defp update_attribution(conn) do
    user_cookie = Map.get(conn.cookies, "_websflyer_id")
    user_id = Map.get(conn.params, "user_id")
    url_params = Map.get(conn.params, "url_params")
    rs_id = Map.get(conn.params, "rs_id")
    conn = case {user_cookie, user_id, url_params, rs_id} do
      {nil, nil, nil, nil} ->
        conn
      {user_cookie, user_id, url_params, _rs_id} when not is_nil(user_cookie) and not is_nil(url_params) and not is_nil(user_id) ->
        Attributions.create_attribution(%{
          "user_id" => user_id,
          "user_cookie" => user_cookie,
          "url_params" => url_params,
          "event" => "click"
        })

        md5_uid = Base.encode16(:crypto.hash(:md5, user_id))
        put_resp_cookie(conn, "_websflyer_u", md5_uid)

      {user_cookie, _user_id, url_params, _rs_id} when not is_nil(user_cookie) and not is_nil(url_params) ->
        Attributions.create_attribution(%{
          "user_cookie" => user_cookie,
          "url_params" => url_params,
          "event" => "click"
        })
        conn
      {user_cookie, user_id, nil, nil} when not is_nil(user_cookie) and not is_nil(user_id)->
        Attributions.create_attribution(%{
          "user_cookie" => user_cookie,
          "user_id" => user_id,
          "event" => "login"
        })

        md5_uid = Base.encode16(:crypto.hash(:md5, user_id))
        put_resp_cookie(conn, "_websflyer_u", md5_uid)

      {nil, user_id, nil, rs_id} when not is_nil(user_id) and not is_nil(rs_id) ->
        Attributions.create_attribution(%{
          "user_id" => user_id,
          "rs_id" => rs_id,
          "event" => "transaction"
        })
        conn
      _ ->
        conn
    end

    conn
  end

  defp should_track?(conn) do
    utm_source = Map.get(conn.private.url_params, "utm_source")
    user_id = Map.get(conn.params, "user_id")
    user_ident_cookie = Map.get(conn.cookies, "_websflyer_u")

    utm_source not in ["", nil] ||
      (user_id not in ["", nil] && (is_nil(user_ident_cookie) || is_changed?(user_ident_cookie, user_id )))
  end

  defp is_changed?(md5hash, id) do
    Base.encode16(:crypto.hash(:md5, id)) != md5hash
  end
  defp serialize_url_params(conn, _opts) do
    url_params = String.trim_leading(Map.get(conn.params, "url_params", ""), "?")
    put_private(conn, :url_params, URI.decode_query(url_params))
  end
end




defmodule WebsFlyer.Affiliates.AttributionTest do
  use WebsFlyer.DataCase

  alias WebsFlyer.Affiliates.Attribution

  @required_attributes %{event: "some event type"}
  @invalid_attributes %{}

  test "changeset with event" do
    changeset = Attribution.changeset(%Attribution{}, @required_attributes)
    assert changeset.valid?
  end
end
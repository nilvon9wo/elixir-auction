defmodule Auction do
  alias Auction.Item

  @repo Auction.SfdcRepo

  def list_items, do: @repo.all(Item)
  def get_item(id), do: @repo.get!(Item, id)
  def get_items_by(attributes), do: @repo.get_by(Item, attributes)
end

defmodule Auction do
  alias Auction.Item

  #  @repo Auction.SfdcRepo
  @repo Auction.Repo

  def list_items, do: @repo.all(Item)
  def get_item(id), do: @repo.get!(Item, id)
  def get_items_by(attributes), do: @repo.get_by(Item, attributes)

  def insert_item(attributes) do
    Auction.Item
    |> struct(attributes)
    |> @repo.insert()
  end

  def delete_item(%Auction.Item{} = item), do: @repo.delete(item)
end

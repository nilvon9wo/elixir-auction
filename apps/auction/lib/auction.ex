defmodule Auction do
  alias Auction.{Repo, Item}

  #  @repo Auction.SfdcRepo
  @repo Auction.Repo

  def new_item, do: Item.changeset(%Item{})

  def insert_item(attributes) do
    %Item{}
    |> Item.changeset(attributes)
    |> @repo.insert()
  end

  def list_items, do: @repo.all(Item)
  def get_item(id), do: @repo.get!(Item, id)
  def get_items_by(attributes), do: @repo.get_by(Item, attributes)

  def edit_item(id) do
    get_item(id)
    |> Item.changeset()
  end

  def update_item(%Auction.Item{} = item, updates) do
    item
    |> Item.changeset(updates)
    |> @repo.update()
  end

  def delete_item(%Auction.Item{} = item), do: @repo.delete(item)
end

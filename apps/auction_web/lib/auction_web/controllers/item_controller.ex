defmodule AuctionWeb.ItemController do
  use AuctionWeb, :controller

  def index(connection, _parameters) do
    items = Auction.list_items()
    render(connection, "index.html", [items: items])
  end

  def show(connection, %{"id" => id}) do
    item = Auction.get_item_with_bids(id)
    bid = Auction.new_bid()
    render(connection, "show.html", [item: item, bid: bid])
  end

  def new(connection, _parameters) do
    item = Auction.new_item()
    render(connection, "new.html", [item: item])
  end

  def create(connection, %{"item" => item_parameters}) do
    case Auction.insert_item(item_parameters) do
      {:ok, item} -> redirect(connection, to: Routes.item_path(connection, :show, item))
      {:error, item} -> render(connection, "new.html", [item: item])
    end
  end

  def edit(connection, %{"id" => id}) do
    item = Auction.edit_item(id)
    render(connection, "edit.html", item: item)
  end

  def update(connection, %{"id" => id, "item" => item_parameters}) do
    item = Auction.get_item(id)
    case Auction.update_item(item, item_parameters) do
      {:ok, item} -> redirect(connection, to: Routes.item_path(connection, :show, item))
      {:error, item} -> render(connection, "edit.html", [item: item])
    end
  end

end

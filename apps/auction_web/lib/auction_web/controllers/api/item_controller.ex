defmodule AuctionWeb.Api.ItemController do
  use AuctionWeb, :controller

  def index(connection, _parameters) do
    items = Auction.list_items()
    render(connection, "index.json", [items: items])
  end

  def show(connection, %{"id" => id}) do
    item = Auction.get_item_with_bids(id)
    render(connection, "show.json", [item: item])
  end
end

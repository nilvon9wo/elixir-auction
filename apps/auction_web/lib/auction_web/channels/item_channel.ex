defmodule AuctionWeb.ItemChannel do
  use Phoenix.Channel

  def join("item:" <> _item_id, _parameters, socket) do
    {:ok, socket}
  end

  def handle_in("new_bid", parameters, socket) do
    broadcast!(socket, "new_bid", parameters)
    {:noreply, socket}
  end

end

defmodule AuctionWeb.BidController do
  use AuctionWeb, :controller
  plug :require_logged_in_user

  def create(
        connection,
        %{
          "bid" => %{
            "amount" => amount
          },
          "item_id" => item_id
        }
      ) do
    current_user = connection.assigns.current_user
    case Auction.insert_bid(%{amount: amount, item_id: item_id, user_id: current_user.id}) do
      {:ok, bid} ->
        html = Phoenix.View.render_to_string(
          AuctionWeb.BidView,
          "bid.html",
          [
            bid: bid,
            username: current_user.username
          ]
        )
        AuctionWeb.Endpoint.broadcast("item:#{item_id}", "new_bid", %{body: html})
        redirect(connection, to: Routes.item_path(connection, :show, bid.item_id))

      {:error, bid} ->
        item = Auction.get_item(item_id)
        render(connection, AuctionWeb.ItemView, 'show.html', [item: item, bid: bid])
    end
  end

  defp require_logged_in_user(connection, _options),
       do: connection
end
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
    user_id = connection.assigns.current_user.id
    case Auction.insert_bid(%{amount: amount, item_id: item_id, user_id: user_id}) do
      {:ok, bid} ->
        redirect(connection, to: Routes.item_path(connection, :show, bid.item_id))

      {:error, bid} ->
        item = Auction.get_item(item_id)
        render(connection, AuctionWeb.ItemView, 'show.html', [item: item, bid: bid])
    end
  end

  defp require_logged_in_user(connection, _options),
    dp: connection
end
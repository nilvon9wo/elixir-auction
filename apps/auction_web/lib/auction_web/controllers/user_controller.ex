defmodule AuctionWeb.UserController do
  use AuctionWeb, :controller
  plug :prevent_unauthorized_access when action in [:show]

  def show(connection, %{"id" => id}) do
    user = Auction.get_user(id)
    bids = Auction.get_bids_for_user(user)
    render connection, "show.html", user: user, bids: bids
  end

  defp prevent_unauthorized_access(connection, _options) do
    current_user = Map.get(connection.assigns, :current_user)

    requested_user_id = connection.params
                        |> Map.get("id")
                        |> String.to_integer()

    if current_user == :nil || current_user.id != requested_user_id do
      connection
      |> put_flash(:error, "Nice try, friend.  That's not a page for you.")
      |> redirect(to: Routes.item_path(connection, :index))
      |> halt()
    else
      connection
    end
  end

  def new(connection, _params) do
    user = Auction.new_user()
    render connection, "new.html", user: user
  end

  def create(connection, %{"user" => user_params}) do
    case Auction.insert_user(user_params) do
      {:ok, user} -> redirect connection, to: Routes.user_path(connection, :show, user)
      {:error, user} -> render connection, "new.html", user: user
    end
  end
end

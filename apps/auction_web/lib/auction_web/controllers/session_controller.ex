defmodule AuctionWeb.SessionController do
  use AuctionWeb, :controller

  import Plug.Conn

  def new(connection, _params) do
    render connection, "new.html"
  end

  def create(
        connection,
        %{
          "user" => %{
            "username" => username,
            "password" => password
          }
        }
      ) do

    case Auction.get_user_by_username_and_password(username, password) do
      %Auction.User{} = user ->
        connection
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Successfully logged in")
        |> redirect(to: Routes.user_path(connection, :show, user))

      _ ->
        connection
        |> put_flash(:error, "That username and password combination cannot be found")
        |> render("new.html")
    end
  end

  def delete(connection, _params) do
    connection
    |> clear_session()
    |> configure_session(drop: :true)
    |> redirect(to: Routes.item_path(connection, :index))
  end
end

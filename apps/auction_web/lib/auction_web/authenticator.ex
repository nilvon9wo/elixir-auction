defmodule AuctionWeb.Authenticator do
  import Plug.Conn

  def init(options),
      do: options

  def call(connection, _options) do
    user = connection
           |> get_session(:user_id)
           |> case do
                :nil -> :nil
                id -> Auction.get_user(id)
              end

    assign(connection, :current_user, user)
  end

end

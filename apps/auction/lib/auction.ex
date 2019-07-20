defmodule Auction do
  alias Auction.{Bid, Item, Password, Repo, User}
  import Ecto.Query

  #  @repo Auction.SfdcRepo
  @repo Auction.Repo

  # Item functions ---------------------------------------------------------------------------------------------

  def new_item, do: Item.changeset(%Item{})

  def insert_item(attributes) do
    %Item{}
    |> Item.changeset(attributes)
    |> @repo.insert()
  end

  def list_items,
      do: @repo.all(Item)

  def get_item(id),
      do: @repo.get!(Item, id)

  def get_item_with_bids(id) do
    id
    |> get_item()
    |> @repo.preload(bids: from(bid in Bid, order_by: [desc: bid.inserted_at]))
    |> @repo.preload(bids: [:user])
  end

  def get_items_by(attributes),
      do: @repo.get_by(Item, attributes)

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

  # User functions ---------------------------------------------------------------------------------------------

  def get_user(id), do: @repo.get!(User, id)
  def new_user, do: User.changeset_with_password(%User{})

  def insert_user(params) do
    %User{}
    |> User.changeset_with_password(params)
    |> @repo.insert
  end

  # Session functions ---------------------------------------------------------------------------------------------

  def get_user_by_username_and_password(username, password) do
    with user when not is_nil(user) <- @repo.get_by(User, %{username: username}),
         :true <- Password.verify_with_hash(password, user.hashed_password) do
      user
    else
      _ -> Password.dummy_verify
    end
  end

  # Bid functions ---------------------------------------------------------------------------------------------

  def get_bids_for_user(user) do
    query = from bid in Bid,
                 where: bid.user_id == ^user.id,
                 order_by: [
                   desc: :inserted_at
                 ],
                 preload: :item,
                 limit: 10
    @repo.all(query)
  end

  def insert_bid(params) do
    %Bid{}
    |> Bid.changeset(params)
    |> @repo.insert
  end

  def new_bid,
      do: Bid.changeset(%Bid{})
end

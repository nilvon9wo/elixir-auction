defmodule Auction.FakeRepo do
  alias Auction.Item

  @items [
    %Item{
      id: 1,
      title: "My first item",
      description: "A tasty item sure to please",
      ends_at: ~N[2020-01-01 00:00:00]
    },
    %Item{
      id: 2,
      title: "WarGames Bluray",
      description: "The best computer movie of all time, now on Bluray!",
      ends_at: ~N[2018-10-15 13:39:35]
    },
    %Item{
      id: 3,
      title: "U2 - Actung Baby on CD",
      description: "The sound of 4 men chopping down The Joshua Tree",
      ends_at: ~N[2018-11-05 03:12:29]
    }
  ]

  def all(Item), do: @items

  def get!(Item, id) do
    has_target_id? = fn item -> item.id == id end
    Enum.find(@items, has_target_id?)
  end

  def get_by(Item, target_attributes) do
    Enum.find(@items, &has_target_attributes?(target_attributes, &1))
  end

  defp has_target_attributes?(target_attributes, item) do
    target_keys = Map.keys(target_attributes)

    has_target_attribute? = fn key ->
      Map.get(item, key) === target_attributes[key]
    end

    Enum.all?(target_keys, has_target_attribute?)
  end
end

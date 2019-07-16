defmodule Auction.SfdcRepo do
  alias Auction.Item

  @sfdc_client Sfdc.Wrapper.get_client!()
  @sfdc_fields ["Id", "Title__c", "Description__c", "Ends_At__c"]
  @sfdc_auction_item "Auction_Item__c"
  @basic_query "SELECT #{Enum.join(@sfdc_fields, ", ")} FROM #{@sfdc_auction_item}"
  @sfdc_key_map %{
    :id => "Id",
    :title => "Title__c",
    :description => "Description__c",
    :ends_at => "Ends_At__c"
  }

  def all(Item) do
    {:ok, %ExForce.QueryResult{records: records}} = ExForce.query(@sfdc_client, @basic_query)
    to_items(records)
  end

  def get!(Item, id) do
    {:ok, sfdc_item} = ExForce.get_sobject(@sfdc_client, id, @sfdc_auction_item, @sfdc_fields)
    to_item(sfdc_item)
  end

  def get_by(Item, %{} = target_attributes) do
    where_clause = build_where_clause(target_attributes)
    query = @basic_query <> where_clause
    {:ok, %ExForce.QueryResult{records: records}} = ExForce.query(@sfdc_client, query)
    to_items(records)
  end

  defp build_where_clause(%{} = target_attributes) do
    target_keys = Map.keys(target_attributes)
    where_phrase_list = build_where_phrase_list(target_attributes, Map.keys(target_attributes))
    build_where_clause(where_phrase_list)
  end

  defp build_where_clause(where_phrase_list = []) do
    ""
  end

  defp build_where_clause(where_phrase_list) when is_list(where_phrase_list) do
    " WHERE " <> Enum.join(where_phrase_list, " AND ")
  end

  def build_where_phrase_list(%{} = target_attributes, target_keys, where_phrase_list \\ []) do
    for (target_key <- target_keys) do
      [build_where_phrase(target_attributes, target_key) | where_phrase_list]
    end
  end

  def build_where_phrase(%{} = target_attributes, target_key) do
    sfdc_key = @sfdc_key_map[target_key]
    target_value = target_attributes[target_key]
    "#{sfdc_key} = '#{target_value}'"
  end

  defp to_items(records) do
    result_list = records
                  |> Enum.to_list()

    for (sfdc_item <- result_list) do
      to_item(sfdc_item)
    end
  end

  def to_item(%ExForce.SObject{:data => data}) do
    %Auction.Item{
      :id => data["Id"],
      :title => data["Title__c"],
      :description => data["Description__c"],
      :ends_at => data["Ends_At__c"]
    }
  end
end

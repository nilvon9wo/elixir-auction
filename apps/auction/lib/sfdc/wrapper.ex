# @see: https://hexdocs.pm/ex_force/ExForce.html
defmodule Sfdc.Wrapper do
  def get_client! do
    {:ok, %{instance_url: instance_url} = oauth_response} = get_token!()
    latest_version = fetch_latest_version(instance_url)
    ExForce.build_client(oauth_response, api_version: latest_version)
  end

  defp fetch_latest_version(instance_url) do
    {:ok, version_maps} = ExForce.versions(instance_url)

    version_maps
    |> Enum.map(&Map.fetch!(&1, "version"))
    |> List.last()
  end

  defp get_token! do
    sfdc_credentials = Application.fetch_env!(:auction, :sfdc_credentials)

    ExForce.OAuth.get_token(
      sfdc_credentials.login_path,
      grant_type: "password",
      client_id: sfdc_credentials.client_id,
      client_secret: sfdc_credentials.client_secret,
      username: sfdc_credentials.username,
      password: sfdc_credentials.password <> sfdc_credentials.security_token
    )
  end
end

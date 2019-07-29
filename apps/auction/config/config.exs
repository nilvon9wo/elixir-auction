use Mix.Config

import_config "../apps/*/config/config.exs"
import_config "#{Mix.env}.exs"

config :phoenix, :json_library, Jason
config :auction, ecto_repos: [Auction.Repo]


use Mix.Config

config :auction, ecto_repos: [Auction.Repo]
import_config "postgres_config.exs"

import_config "sfdc_config.exs"

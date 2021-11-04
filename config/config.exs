import Config

import_config "#{Mix.env()}.exs"

config :air_price, air_france_key: System.fetch_env!("AIR_FRANCE_KEY")
config :air_price, british_airways_key: System.fetch_env!("BRITISH_AIRWAYS_KEY")

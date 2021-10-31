import Config

config :logger, level: :notice
config :air_price, port: System.fetch_env!('PORT')

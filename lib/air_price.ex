defmodule AirPrice do
  use Application
  require Logger

  def start(_type, args) do
    %{port: port} = Enum.into(args, %{})

    children = [
      {Plug.Cowboy,
       scheme: :http, plug: AirPrice.ApiHandler, options: [port: port]}
    ]

    Logger.notice("Listening on port #{port}...")
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end

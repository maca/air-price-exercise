defmodule AirPrice.Providers do
  require Logger

  @providers [AirPrice.Providers.AirFrance, AirPrice.Providers.British]

  def find_cheapest(params) do
    fetch(params)
    |> Enum.max_by(fn %{amount: amount} -> amount end, fn -> nil end)
  end

  def fetch(params) do
    AirPrice.FetchSupervisor
    |> Task.Supervisor.async_stream_nolink(@providers, fn module ->
      fetch(module, params)
    end)
    |> Stream.flat_map(&map_responses/1)
    |> Enum.to_list()
  end

  def fetch(module, params), do: apply(module, :fetch, [params])

  defp map_responses({:ok, offers}) when is_list(offers), do: offers
  defp map_responses(_error), do: []
end

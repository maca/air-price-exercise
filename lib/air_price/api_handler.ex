defmodule AirPrice.ApiHandler do
  use Plug.Router

  plug Plug.Parsers, parsers: [:urlencoded]
  plug Plug.Logger, log: :info
  plug :match
  plug :dispatch

  get "/findCheapestOffer" do
    date = conn.params["departureDate"]
    origin = conn.params["origin"]
    destination = conn.params["destination"]

    offer =
      AirPrice.Providers.find_cheapest(%{
        date: date,
        origin: origin,
        destination: destination
      })

    body = Poison.encode!(%{data: %{cheapestOffer: offer}})
    send_resp(conn, 200, body)
  end

  match _ do
    send_resp(conn, 404, "Not found!")
  end
end

defmodule AirPrice.ApiHandler do
  use Plug.Router

  plug(Plug.Logger, log: :info)
  plug(:match)
  plug(:dispatch)

  get "/findCheapestOffer" do
    conn |> send_resp(200, "Hello world!")
  end

  match _ do
    send_resp(conn, 404, "Not found!")
  end
end

defmodule AirPrice.Providers.Soap do
  defmacro __using__(opts) do
    %{url: url, headers: extra_headers} = Enum.into(opts, %{})
    headers = ["Content-Type": "application/xml"] ++ extra_headers

    quote do
      import SweetXml, only: [sigil_x: 2]

      def fetch(params) do
        {:ok, %{body: body, status_code: 200}} =
          HTTPoison.request(request(params))

        %{offers: offers} = parse(body)
        offers
      end

      defp request(params) do
        %HTTPoison.Request{
          method: :post,
          url: unquote(url),
          headers: unquote(headers),
          body: request_body(params)
        }
      end
    end
  end
end

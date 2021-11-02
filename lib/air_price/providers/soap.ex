defmodule AirPrice.Providers.Soap do
  defmacro __using__(opts) do
    %{url: url, headers: extra_headers} = Enum.into(opts, %{})
    headers = ["Content-Type": "application/xml"] ++ extra_headers

    quote do
      import SweetXml, only: [sigil_x: 2]

      def fetch(params) do
        case HTTPoison.request(request(params)) do
          {:ok, %{body: body, status_code: 200}} ->
            %{offers: offers} = parse(body)
            offers

          err ->
            err
        end
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

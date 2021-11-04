defmodule AirPrice.Providers.British do
  use AirPrice.Providers.Soap,
    url: "https://test.api.ba.com/selling-distribution/AirShopping/V2",
    headers: [
      "Client-Key": Application.fetch_env!(:air_price, :british_airways_key),
      soapaction: "AirShoppingV01"
    ]

  defp parse(resp_body) do
    SweetXml.xmap(resp_body,
     offers: [
        ~x"//AirlineOffer"l,
        provider: ~x"'BA'"s,
        amount: ~x"./TotalPrice/SimpleCurrencyPrice/text()"f
      ]
    )
  end

  def request_body(%{date: date, origin: origin, destination: destination}) do
    """
    <?xml version="1.0"?>
    <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
      <s:Body xmlns="http://www.iata.org/IATA/EDIST">
        <AirShoppingRQ xmlns="http://www.iata.org/IATA/EDIST" Version="3.0">
          <PointOfSale>
            <Location>
              <CountryCode>DE</CountryCode>
            </Location>
                </PointOfSale>
                <Document/>
                <Party>
            <Sender>
              <TravelAgencySender>
                <Name>test agent</Name>
                <IATA_Number>00002004</IATA_Number>
                <AgencyID>test agent</AgencyID>
              </TravelAgencySender>
            </Sender>
                </Party>
                <Travelers>
            <Traveler>
              <AnonymousTraveler>
                <PTC Quantity="1">ADT</PTC>
              </AnonymousTraveler>
            </Traveler>
                </Travelers>
                <CoreQuery>
            <OriginDestinations>
              <OriginDestination>
                <Departure>
                  <AirportCode>#{origin}</AirportCode>
                  <Date>#{date}</Date>
                </Departure>
                <Arrival>
                  <AirportCode>#{destination}</AirportCode>
                </Arrival>
              </OriginDestination>
            </OriginDestinations>
          </CoreQuery>
        </AirShoppingRQ>
      </s:Body>
    </s:Envelope>
    """
  end
end

defmodule AirPrice.Providers.AirFrance do
  use AirPrice.Providers.Soap,
    url: "https://ndc-rct.airfranceklm.com/passenger/distribmgmt/001448v02/EXT",
    headers: [
      soapaction:
        ~s("http://www.af-klm.com/services/passenger/ProvideAirShopping/airShopping"),
      api_key: "xxxxxx"
    ]

  defp parse(resp_body) do
    SweetXml.xmap(resp_body,
      offers: [
        ~x"//ns2:Offer"l,
        provider: ~x"'AFKL'"s,
        amount: ~x"./ns2:TotalPrice/ns2:TotalAmount/text()"f
      ]
    )
  end

  defp request_body(%{date: date, origin: origin, destination: destination}) do
    """
    <?xml version="1.0"?>
    <S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns="http://www.iata.org/IATA/2015/00/2018.2/IATA_AirShoppingRQ">
      <S:Header/>
      <S:Body>
        <IATA_AirShoppingRQ>
          <Party>
            <Participant>
              <Aggregator>
                <AggregatorID>NDCABT</AggregatorID>
                <Name>NDCABT</Name>
              </Aggregator>
            </Participant>
            <Recipient>
              <ORA>
                <AirlineDesigCode>AF</AirlineDesigCode>
              </ORA>
            </Recipient>
            <Sender>
              <TravelAgency>
                <AgencyID>12345675</AgencyID>
                <IATANumber>12345675</IATANumber>
                <Name>nom</Name>
                <PseudoCityID>PAR</PseudoCityID>
              </TravelAgency>
            </Sender>
          </Party>
          <PayloadAttributes>
            <CorrelationID>5</CorrelationID>
            <VersionNumber>18.2</VersionNumber>
          </PayloadAttributes>
          <Request>
            <FlightCriteria>
              <OriginDestCriteria>
                <DestArrivalCriteria>
                  <IATALocationCode>#{destination}</IATALocationCode>
                </DestArrivalCriteria>
                <OriginDepCriteria>
                  <Date>#{date}</Date>
                  <IATALocationCode>#{origin}</IATALocationCode>
                </OriginDepCriteria>
                <PreferredCabinType>
                  <CabinTypeName>ECONOMY</CabinTypeName>
                </PreferredCabinType>
              </OriginDestCriteria>
            </FlightCriteria>
            <Paxs>
              <Pax>
                <PaxID>PAX1</PaxID>
                <PTC>ADT</PTC>
              </Pax>
            </Paxs>
          </Request>
        </IATA_AirShoppingRQ>
      </S:Body>
    </S:Envelope>
    """
  end
end

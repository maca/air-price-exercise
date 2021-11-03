# Air Price Excercise for Priceline


When running on dev it will provide a REST JSON interface at port 4000 with a
single endpoint `/findCheapestOffer`.

Which will return a single offer with the lowest price if found, otherwise it
will return null.


## Endpoint `/findCheapestOffer`

Parameters

  - origin: IATA code for origin airport
  - destination: IATA code for destination airport
  - departureDate: Date of the departure in the format "YYYY-MM-DD"


Example request:

http://localhost:4000/findCheapestOffer?origin=BER&destination=LHR&departureDate=2021-12-12


## Implementation

Application supervisor is defined at `lib/air_price.ex`

`Cowboy` and `Plug` are used to serve http.

The module `AirPrice.Providers` at `lib/air_price/providers.ex` exposes
`find_cheapest/1`, `fetch/1` and `fetch/2`, the first returns the cheapeast offer
if any and the second all of the offers matching the criteria.

Fetching from all SOAP providers is performed concurrently using supervised
`Task`s.
If a request fails it will be logged, but it will not prevent getting
results from other providers.


Each of `AirPrice.Poviders.AirFrance` and `AirPrice.Providers.British` use a
macro module `AirPrice.Providers.Soap` that will define the common functions for
consuming the SOAP API. A SOAP provider must implement `request_body/1` and
`parse/1`.

Credentials have been harcoded but they could be defined in the config for
environments as defaults and read from the environment.

No tests have been written, but I generally write enough unit tests to have
confidence to refactor and as many integration tests to a have a good degree of
confidence.

To mock requests I tend to define a Mock Plug server and dependency inject the
url, here's an exaple for some other code exercise.

https://github.com/maca/air-quality-exercise/blob/master/test/mock_server.exs

taken from here:

https://medium.com/flatiron-labs/rolling-your-own-mock-server-for-testing-in-elixir-2cdb5ccdd1a0

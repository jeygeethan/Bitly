# README

## Without using a DB

We can use hashing to generate a unique hash for the given long url. This can eliminate the database. But the limitations would be:

1. Hash would be longer in length
2. We will not be able to store any reporting data such as created_at, count of visits etc
3. Reverse mapping from slug to redirection cannot happen

## Error Handling

Error handling is done at each step of the way. We are doing while we are generating the slug, while redirecting, while fetching the long_url for a given slug. The error response will always be a json with correct http response code.

## Authentication

Currently the app is a global app, which means that long urls are unique across the system. If we add authentication, we can create shortened urls unique to an user to track metrics like visit count etc.

Authentication can be done using API either via

1. Basic auth (sending email:password in headers) - not recommended due to password being present. MITM attacks can capture data even if through HTTPS
2. API secret key tokens - An user can create a api key and use that key as headers in all requests to authenticate. This helps to invalidate the key incase of breach

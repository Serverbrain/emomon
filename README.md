# Emomon
Real-time Forms with Phoenix and Websockets

This is a little experiment that shows how to use [Phoenixframework](http://www.phoenixframework.org)
for realtime forms via websockets. 

![Emomon Demo](/priv/emomon.gif?raw=true "Emomon Demo Animgif")

An interesting approach to saving state of a small app is the self-saving [GenServer](http://elixir-lang.org/getting-started/mix-otp/genserver.html)
- certainly not for terabytes of data, but for some small collections of values, why not?


To start this Phoenix app:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

(C) 2016 Tomas Juriga

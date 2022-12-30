# LightsOutGame

ref: <https://youtu.be/hrpulBR5PFg>

## Installation Step

### elixir and erlang

if you don't have an elixir and erlang

```sh
$brew install elixir
$brew install erlang

$mix local.rebar --force
$mix local.hex --force

$mix do archive.build + archive.install
$mix archive.install hex phx_new
```

### Set up project Phoenix

```sh
$mix phx.new lights_out_game --no-ecto
```

### Set up tailwind CSS

ref: <https://tailwindcss.com/docs/guides/phoenix>

### Set up Alpine.JS

ref: <https://fullstackphoenix.com/tutorials/combine-phoenix-liveview-with-alpine-js>

### Set up a LiveView Component

***set in a live folder and set it in `router.ex`***

```ex
  # get "/", PageController, :index
  live "/", Board
```

ref: <https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#content>

## To start your Phoenix server

* Install dependencies with `mix deps.get`
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

* Official website: <https://www.phoenixframework.org/>
* Guides: <https://hexdocs.pm/phoenix/overview.html>
* Docs: <https://hexdocs.pm/phoenix>
* Forum: <https://elixirforum.com/c/phoenix-forum>
* Source: <https://github.com/phoenixframework/phoenix>

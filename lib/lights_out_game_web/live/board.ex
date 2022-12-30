defmodule LightsOutGameWeb.Board do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    grid = for x <- 0..4, y <- 0..4, do: {{x, y}, false}

    {:ok, assign(socket, grid: grid)}
  end
end

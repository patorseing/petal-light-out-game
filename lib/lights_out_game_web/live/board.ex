defmodule LightsOutGameWeb.Board do
  require Logger
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    grid = for x <- 0..4, y <- 0..4, do: {{x, y}, false}

    {:ok, assign(socket, grid: grid)}
  end

  def handle_event("toggle", %{"x" => strX, "y" => strY, "i" => index}, socket) do

    grid = socket.assigns.grid
    grid_x = String.to_integer(strX)
    grid_y = String.to_integer(strY)
    grid_i = String.to_integer(index)

    updated_grid = List.update_at(grid, grid_i, &({{grid_x, grid_y}, !elem(&1,1)}))

    {:noreply, assign(socket, :grid, updated_grid)}
  end
end

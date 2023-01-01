defmodule LightsOutGameWeb.Board do
  require Logger
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    grid = for x <- 0..4, y <- 0..4, do: {{x, y}, false}

    {:ok, assign(socket, grid: grid)}
  end

  def handle_event("toggle", %{"i" => index}, socket) do
    grid = socket.assigns.grid
    grid_i = String.to_integer(index)

    updated_grid =
      Enum.map(Enum.with_index(grid), fn {item, i} ->
        if Enum.member?(Enum.uniq([grid_i | find_adjacent_tile(grid_i)]), i) do
          {elem(item, 0), !elem(item, 1)}
        else
          item
        end
      end)

    {:noreply, assign(socket, :grid, updated_grid)}
  end

  def find_adjacent_tile(i) do
    left = i - 1
    right = i + 1
    upper = i + 5
    down = i - 5

    Enum.filter([left, upper, right, down], fn x -> x >= 0 end)
  end
end

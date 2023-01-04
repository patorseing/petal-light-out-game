defmodule LightsOutGameWeb.Board do
  require Logger
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    grid = for x <- 0..4, y <- 0..4, into: %{}, do: {{x, y}, false}

    {:ok, assign(socket, grid: grid, count: 0, win: false)}
  end

  def handle_event("start", %{}, socket) do
    grid = socket.assigns.grid

    # level1 = %{{2, 0} => true, {2, 2} => true, {2, 4} => true}

    # grid = Map.merge(grid, level1)

    level_ransom = generate_puzzle()

    grid = Map.merge(grid, level_ransom)
    # grass(grid)
    # level_ransom = for !grid = Map.merge(grid, level_ransom)

    # updated_grid = Enum.reduce(grid, fn point, acc -> Map.put(acc, point, !grid[point]) end)
    {:noreply, assign(socket, grid: grid, count: 0, win: false)}
  end

  def generate_puzzle() do
    level = for x <- 0..4, y <- 0..4, into: %{}, do: {{x, y}, rem(x + y, Enum.random(2..3)) == 0}

    if issolvable(level) do
      level
    else
      generate_puzzle()
    end
  end

  def handle_event("toggle", %{"x" => strX, "y" => strY}, socket) do
    grid = socket.assigns.grid
    count = socket.assigns.count + 1
    grid_x = String.to_integer(strX)
    grid_y = String.to_integer(strY)

    updated_grid =
      find_adjacent_tile(grid_x, grid_y)
      |> Enum.reduce(%{}, fn point, acc -> Map.put(acc, point, !grid[point]) end)
      |> then(fn toggled_grid -> Map.merge(grid, toggled_grid) end)

    win = check_win(updated_grid)
    socket = assign(socket, grid: updated_grid, count: count, win: win)

    case win do
      true -> {:noreply, push_event(socket, "gameover", %{win: win})}
      _ -> {:noreply, socket}
    end

    {:noreply, assign(socket, grid: updated_grid, count: count, win: win)}
  end

  defp find_adjacent_tile(x, y) do
    prevX = Kernel.max(0, x - 1)
    nextX = Kernel.min(4, x + 1)
    prevY = Kernel.max(0, y - 1)
    nextY = Kernel.min(4, y + 1)

    [{x, y}, {prevX, y}, {nextX, y}, {x, prevY}, {x, nextY}]
  end

  defp check_win(grid) do
    grid
    |> Map.values()
    |> Enum.all?(fn light -> !light end)
  end

  def issolvable(puzzle) when is_map(puzzle) do
    # Flatten the puzzle into a list of integers
    flat_puzzle = for {x, y, on} <- puzzle, do: on

    # Count the number of 1s in the puzzle
    num_ones = Enum.count(flat_puzzle, 1)

    # The puzzle is solvable if the number of 1s is even
    rem(num_ones, 2) == 0
  end
end

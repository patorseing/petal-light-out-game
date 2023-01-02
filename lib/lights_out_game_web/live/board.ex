defmodule LightsOutGameWeb.Board do
  require Logger
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    grid = for x <- 0..4, y <- 0..4, into: %{}, do: {{x, y}, false}

    coefficient = get_coefficient()
    pivot = get_pivot(grid)

    {:ok,
     assign(socket, grid: grid, count: 0, win: false, coefficient: coefficient, pivot: pivot)}
  end

  def handle_event("start", %{}, socket) do
    grid = socket.assigns.grid

    level1 = %{{2, 0} => true, {2, 2} => true, {2, 4} => true}

    grid = Map.merge(grid, level1)

    # grass(grid)
    # level_ransom =
    #   for x <- 0..4, y <- 0..4, into: %{}, do: {{x, y}, rem(x + y, Enum.random(2..3)) == 0}

    # grid = Map.merge(grid, level_ransom)

    coefficient = get_coefficient()
    pivot = get_pivot(grid)
    gauss_elimination(coefficient, pivot)

    # updated_grid = Enum.reduce(grid, fn point, acc -> Map.put(acc, point, !grid[point]) end)
    {:noreply,
     assign(socket, grid: grid, count: 0, win: false, coefficient: coefficient, pivot: pivot)}
  end

  def handle_event("toggle", %{"x" => strX, "y" => strY}, socket) do
    grid = socket.assigns.grid
    coefficient = socket.assigns.coefficient
    pivot = socket.assigns.pivot
    count = socket.assigns.count + 1
    grid_x = String.to_integer(strX)
    grid_y = String.to_integer(strY)

    updated_grid =
      find_adjacent_tile(grid_x, grid_y)
      |> Enum.reduce(%{}, fn point, acc -> Map.put(acc, point, !grid[point]) end)
      |> then(fn toggled_grid -> Map.merge(grid, toggled_grid) end)

    win = check_win(updated_grid)

    socket =
      assign(socket,
        grid: updated_grid,
        count: count,
        win: win,
        coefficient: coefficient,
        pivot: pivot
      )

    case win do
      true -> {:noreply, push_event(socket, "gameover", %{win: win})}
      _ -> {:noreply, socket}
    end
  end

  defp find_adjacent_tile(x, y) do
    prevX = Kernel.max(0, x - 1)
    nextX = Kernel.min(4, x + 1)
    prevY = Kernel.max(0, y - 1)
    nextY = Kernel.min(4, y + 1)

    [{x, y}, {prevX, y}, {nextX, y}, {x, prevY}, {x, nextY}]
  end

  defp check_win(grid) do
    get_pivot(grid)
    |> Enum.all?(fn light -> !light end)
  end

  defp get_coefficient() do
    transpose(
      for i <- 0..4,
          j <- 0..4,
          do: for(x <- 0..4, y <- 0..4, do: Enum.member?(find_adjacent_tile(i, j), {x, y}))
    )
  end

  def transpose(matrix) do
    cols = Enum.count(Enum.at(matrix, 0))

    Enum.map(1..cols, fn c ->
      Enum.map(matrix, fn row -> Enum.at(row, c - 1) end)
    end)
  end

  defp get_pivot(grid) do
    grid
    |> Map.values()
  end

  defp gauss_elimination(a, b) do
    n = Enum.count(a)

    # Forward elimination
    for i <- 0..(n - 2) do
      for j <- (i + 1)..(n - 1) do
        m = boolean_to_integer(getList(a, j, i)) / boolean_to_integer(getList(a, i, i))

        # for k <- i..(n - 1) do
        #   getList(a, j, k) = getList(a, j, k) - m * getList(a, i, k)
        # end
      end
    end
  end

  defp getList(a, x, y) do
    Enum.at(Enum.at(a, x), y)
  end

  def boolean_to_integer(bool) do
    if bool, do: 1, else: 0
  end
end

defmodule LightOutGameSolver do
  require Logger

  def solve(grid) do
    n = length(grid)
    m = length(Enum.at(grid, 0))

    # Keep track of the positions that need to be toggled
    # toggles = []

    # Iterate over each light in the grid
    toggle =
      for y <- 0..(n - 1), x <- 0..(m - 1) do
        # Check the state of the current light and its neighbors
        neighbors = [
          Enum.at(grid, y - 1, x - 1),
          Enum.at(grid, y - 1, x),
          Enum.at(grid, y - 1, x + 1),
          Enum.at(grid, y, x - 1),
          Enum.at(grid, y, x + 1),
          Enum.at(grid, y + 1, x - 1),
          Enum.at(grid, y + 1, x),
          Enum.at(grid, y + 1, x + 1)
        ]

        # If the light is on, add its position to the toggles list
        if Enum.at(Enum.at(grid, y), x) == 1 do
          {y, x}
          # If an odd number of neighbors are on, add the current position to the toggles list
        else
          if rem(Enum.count(neighbors), 2) == 1 do
            {y, x}
          end
        end
      end

    # Return the list of positions to be toggled
    toggle
  end
end

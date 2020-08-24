defmodule CommonsPub.Core.Maps do

  def rename(map, changes) do
    Enum.reduce(changes, map, fn {k, l}, map ->
      case map do
        %{^k => v} -> Map.put(Map.delete(map, k), l, v)
        _ -> map
      end
    end)
  end

end

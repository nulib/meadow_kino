defmodule Meadow.Kino.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Kino.SmartCell.register(Meadow.Kino.DBConnectionCell)
    Kino.SmartCell.register(Meadow.Kino.RemoteExecutionCell)
    {:ok, self()}
  end
end

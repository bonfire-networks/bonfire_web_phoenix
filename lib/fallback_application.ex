defmodule Bonfire.WebPhoenix.FallbackApplication do
  @moduledoc false

  @sup_name Bonfire.WebPhoenix.Supervisor

  use Application

  def start(_type, _args) do
    IO.inspect("starting web...")

    Supervisor.start_link(
      [
        # Pointers.Tables,
        Bonfire.WebPhoenix.Telemetry,
        # Bonfire.Common.Repo,
        {Phoenix.PubSub, name: Bonfire.PubSub},
        Bonfire.WebPhoenix.Endpoint

        # {Oban, Bonfire.Common.Config.get_ext(:bonfire, Oban)}
      ],
      strategy: :one_for_one,
      name: @sup_name
    )
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Bonfire.WebPhoenix.Endpoint.config_change(changed, removed)
    :ok
  end
end

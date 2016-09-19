defmodule Emomon do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(Emomon.Endpoint, []),
      # Start your own worker by calling: Emomon.Worker.start_link(arg1, arg2, arg3)
      # worker(Emomon.Worker, [arg1, arg2, arg3]),
      worker(Emomon.Emostore, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Emomon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Emomon.Endpoint.config_change(changed, removed)
    :ok
  end

  def version(app \\ :emomon) do
    Application.loaded_applications
    |> Enum.filter(&(elem(&1, 0 ) == app))
    |> List.first
    |> elem(2)
    |> to_string
  end
  
end

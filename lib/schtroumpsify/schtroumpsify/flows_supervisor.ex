defmodule Schtroumpsify.FlowsSupervisor do
  @moduledoc false
  use DynamicSupervisor

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one, max_seconds: 30)
  end

  def startFlow(tweet) do
    spec = %{id: Schtroumpsify.FlowRunner, start: {Schtroumpsify.FlowRunner, :start_link, [tweet]}, restart: :transient}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

end

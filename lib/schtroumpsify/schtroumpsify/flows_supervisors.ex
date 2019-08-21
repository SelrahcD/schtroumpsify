defmodule Schtroumpsify.FlowsSupervisors do
  @moduledoc false
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, strategy: :one_for_one, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def startFlow(tweet) do
    spec = %{id: Schtroumpsify.FlowRunner, start: {Schtroumpsify.FlowRunner, :start_link, [tweet]}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

end

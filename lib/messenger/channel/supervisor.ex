defmodule Messenger.Channel.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_channel(name) do
    Supervisor.start_child(__MODULE__, [name])
  end

  def start_channel(user1, user2) do
    Supervisor.start_child(__MODULE__, [user1, user2])
  end

  def init(:ok) do
    children = [
      worker(Messenger.Channel, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end
end

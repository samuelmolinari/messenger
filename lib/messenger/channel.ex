defmodule Messenger.Channel do
  defstruct name: nil, users: [], messages: []
  use GenServer

  def start_link(name) when is_bitstring(name) do
    server_name = String.to_atom(name <> "_channel")
    GenServer.start_link(__MODULE__, {:ok, name}, name: server_name)
  end

  def join(channel, user) do
    GenServer.call(channel, {:join, user})
  end

  def message(channel, text) do
    GenServer.cast(channel, {:message, %Messenger.Message{body: text, sent_at: :calendar.universal_time()}})
  end

  def get(channel) do
    GenServer.call(channel, {:get})
  end

  def init({:ok, name}) do
    {:ok, %Messenger.Channel{name: name}}
  end

  def handle_call({:join, user}, _from, channel) do
    users = channel.users
    channel = %Messenger.Channel{channel | users: [user|users]}
    {:reply, user, channel}
  end

  def handle_call({:get}, _from, channel) do
    {:reply, channel, channel}
  end

  def handle_cast({:message, message}, channel) do
    messages = channel.messages
    channel = %Messenger.Channel{channel | messages: [message|messages]}
    {:noreply, channel}
  end
end

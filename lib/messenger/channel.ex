defmodule Messenger.Channel do
  defstruct name: nil, users: [], messages: []
  use GenServer

  def start_link(name) when is_bitstring(name) do
    server_name = server(name)
    GenServer.start_link(__MODULE__, {:ok, name}, name: server_name)
  end

  def start_link(user1, user2) do
    server_name = server(user1, user2)
    GenServer.start_link(__MODULE__, {:ok, user1, user2}, name: server_name)
  end

  def server(name) do
    String.to_atom(name <> "_channel")
  end

  def server(user1, user2) do
    n1 = String.downcase(user1.username)
    n2 = String.downcase(user2.username)

    name = if n1 < n2, do: "#{n1}_#{n2}", else: "#{n2}_#{n1}"

    String.to_atom(name <> "_dm")
  end

  def join(channel, user) do
    GenServer.call(channel, {:join, user})
  end

  def message(channel, user, text) do
    GenServer.cast(channel, {:message, %Messenger.Message{body: text, user: user, sent_at: :calendar.universal_time()}})
  end

  def get(channel) do
    GenServer.call(channel, {:get})
  end

  def init({:ok, name}) do
    {:ok, %Messenger.Channel{name: name}}
  end

  def init({:ok, user1, user2}) do
    {:ok, %Messenger.Channel{name: "#{user1.username}, #{user2.username}"}}
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

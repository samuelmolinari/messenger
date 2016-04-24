defmodule Messenger.Message do
  defstruct user: nil, sent_at: nil, body: nil

  def send(from: user, to: "#" <> channel, content: content) do
    server = Messenger.Channel.server(channel)
    Messenger.Message.send(from: user, to: server, content: content)
  end

  def send(from: user, to: "@" <> username, content: content) do
    recipient = Messenger.User.find_by_username(username)
    server = Messenger.Channel.server(user, recipient)
    Messenger.Channel.Supervisor.start_channel(user, recipient)
    Messenger.Message.send(from: user, to: server, content: content)
  end

  def send(from: user, to: server, content: content) do
    Messenger.Channel.message(server, user, content)
  end
end

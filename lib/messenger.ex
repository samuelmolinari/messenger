defmodule Messenger do
  use Application

  def start(_type, _args) do
    Messenger.Channel.Supervisor.start_link
  end
end

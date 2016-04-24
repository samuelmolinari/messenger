defmodule Messenger.User do
  defstruct username: nil

  def find_by_username(username) do
    %Messenger.User{username: String.downcase(username)}
  end
end

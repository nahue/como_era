defmodule ComoEra.Repo do
  use Ecto.Repo,
    otp_app: :como_era,
    adapter: Ecto.Adapters.SQLite3
end

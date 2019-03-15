defmodule Notebook.Repo do
  use Ecto.Repo,
    otp_app: :notebook,
    adapter: Ecto.Adapters.Postgres
end

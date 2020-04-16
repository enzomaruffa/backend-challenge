defmodule Reflections.Repo do
  use Ecto.Repo,
    otp_app: :reflections,
    adapter: Ecto.Adapters.Postgres
end

defmodule NoraxCore.Repo do
  use Ecto.Repo,
    otp_app: :norax,
    adapter: Ecto.Adapters.Postgres
end

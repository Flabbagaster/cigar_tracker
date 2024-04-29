defmodule Cigar.Repo do
  use Ecto.Repo,
    otp_app: :cigar,
    adapter: Ecto.Adapters.Postgres
end

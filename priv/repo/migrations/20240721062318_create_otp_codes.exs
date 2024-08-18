defmodule NoraxCore.Repo.Migrations.CreateOtpCodes do
  use Ecto.Migration

  def change do
    create table(:otp_codes, primary_key: false) do
      add :email, :string, size: 160, primary_key: true, null: false
      add :secret, :binary, null: false

      add :code, :string

      timestamps(type: :timestamptz)
    end
  end
end

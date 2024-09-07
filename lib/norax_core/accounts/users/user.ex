defmodule NoraxCore.Accounts.Users.User do
  @moduledoc """
  `User` schema
  """
  use NoraxCore, :schema

  alias __MODULE__

  schema "users" do
    field :first_name, :string
    field :last_name, :string, default: ""

    field :email, :string
    field :password, :string, redact: true

    field :avatar_url, :string, default: ""
    field :role, Ecto.Enum, values: ~w(user admin)a, default: :user

    field :otp_secret, :binary, autogenerate: {NimbleTOTP, :secret, []}, redact: true
    field :verified?, :boolean, source: :is_verified, default: false

    field :code, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user \\ %User{}, params) when not is_struct(params) do
    required_fields = ~w(first_name email password)a
    optional_fields = ~w(last_name avatar_url role otp_secret verified? code)a

    user
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:id, name: :users_pkey)
    |> validate_length(:first_name, min: 2, max: 255)
    |> validate_length(:last_name, max: 255)
    |> unique_constraint(:email, name: :users_email_index)
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:email, min: 3, max: 160)
    |> validate_format(:email, ~r/^[.!?@#$%^&*_+a-z\-0-9]+[@][._+\-a-z0-9]+$/)
    |> validate_length(:code, is: 6)
    |> validate_format(:code, ~r/^[0-9]{6}$/, message: "must be only number(s)")
    |> validate_length(:password, min: 6, max: 72)
    |> validate_length(:password, max: 72, count: :bytes)
    |> validate_format(:password, ~r/[0-9]/, message: "must have number(s)")
    |> validate_format(:password, ~r/[a-z]/, message: "must have lower case character(s)")
    |> validate_format(:password, ~r/[A-Z]/, message: "must have upper case character(s)")
    |> validate_format(:password, ~r/[.!?@#$%^&*_+\-]/, message: "must have special character(s)")
    |> update_change(:password, &Argon2.hash_pwd_salt/1)
    |> update_change(:avatar_url, &String.downcase/1)
    |> validate_length(:avatar_url, max: 255)
  end
end

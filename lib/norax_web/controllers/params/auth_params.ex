defmodule NoraxWeb.Controllers.AuthParams do
  @moduledoc false
  use NoraxWeb, :params

  defparams :email do
    required(:email, :string, format: :email, min: 3, max: 160, trim: true)
  end

  defparams :signup do
    required(:code, :string, is: 6, trim: true)

    required :user, :map do
      required(:first_name, :string, min: 2, max: 255, squish: true)
      optional(:last_name, :string, max: 255, squish: true)

      required(:email, :string, format: :email, min: 3, max: 160, trim: true)
      required(:password, :string, format: :password, min: 6, max: 72, trim: true)

      optional(:avatar_url, :string, format: :url, max: 255)
      optional(:role, :enum, values: ~w(user admin))
    end
  end

  defparams :signin do
    required :credentials, :map do
      required(:email, :string, format: :email, min: 3, max: 160, trim: true)
      required(:password, :string, trim: true)
    end
  end
end

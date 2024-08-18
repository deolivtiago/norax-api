defmodule NoraxWeb.Controllers.UserParams do
  @moduledoc false
  use NoraxWeb, :params

  defparams :create do
    required :user, :map do
      required(:first_name, :string, min: 2, max: 255, squish: true)
      optional(:last_name, :string, max: 255, squish: true)

      required(:email, :string, format: :email, min: 3, max: 160, trim: true)
      required(:password, :string, format: :password, min: 6, max: 72, trim: true)

      optional(:avatar_url, :string, format: :url, max: 255)
      optional(:role, :enum, values: ~w(user admin))
    end
  end

  defparams :show do
    required(:id, :uuid)
  end

  defparams :update do
    required(:id, :uuid)

    required :user, :map do
      required(:first_name, :string, min: 2, max: 255, squish: true)
      optional(:last_name, :string, max: 255, squish: true)

      required(:email, :string, format: :email, min: 3, max: 160, trim: true)

      optional(:avatar_url, :string, max: 255, format: :url)
      optional(:role, :enum, values: ~w(user admin))
    end
  end

  defparams :delete do
    required(:id, :uuid)
  end
end

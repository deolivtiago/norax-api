defmodule NoraxCore do
  @moduledoc """
  NoraxCore keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.

  This can be used in your application as:

      use NoraxCore, :schema
      use NoraxCore, :validation

  """

  def schema do
    quote do
      use Ecto.Schema

      unquote(validation())

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id

      def changeset, do: %{change(struct(__MODULE__)) | valid?: false}
    end
  end

  def validation do
    quote do
      import Ecto.Changeset

      defp cast(schema, params) when is_non_struct_map(schema) or is_list(schema) do
        %{Goal.build_changeset(schema, params) | valid?: false}
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

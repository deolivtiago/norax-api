defmodule NoraxWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use NoraxWeb, :controller
      use NoraxWeb, :html
      use NoraxWeb, :params

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: NoraxWeb.Layouts]

      import Plug.Conn
      import NoraxWeb.Gettext

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: NoraxWeb.Endpoint,
        router: NoraxWeb.Router,
        statics: NoraxWeb.static_paths()
    end
  end

  def params do
    quote do
      import Goal

      @doc """
      Returns the validated parameters or an error changeset.
      """
      def validate(name, params, opts \\ []) when is_map(params) and is_list(opts) do
        key = Keyword.get(opts, :into)

        with {:ok, params} <- validate_params(schema(name), params, opts) do
          if is_nil(key) or not is_atom(key),
            do: {:ok, params},
            else:
              Map.new()
              |> Map.put(key, params)
              |> then(&{:ok, &1})
        end
      end
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

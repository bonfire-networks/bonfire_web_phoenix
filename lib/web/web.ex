defmodule CommonsPub.WebPhoenix do
  @moduledoc false

  def controller do
    quote do
      use Phoenix.Controller, namespace: CommonsPub.WebPhoenix

      import Plug.Conn
      import CommonsPub.WebPhoenix.Gettext
      alias CommonsPub.WebPhoenix.Router.Helpers, as: Routes

      import CommonsPub.WebPhoenixHelpers

    end
  end

  def view(root \\ "lib/web/templates") do
    quote do
      # IO.inspect(vox_root: unquote(root))

      use Phoenix.View,
        root: unquote(root),
        pattern: "**/*",
        namespace: CommonsPub.WebPhoenix

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {CommonsPub.WebPhoenix.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import CommonsPub.WebPhoenix.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import CommonsPub.WebPhoenix.ErrorHelpers
      import CommonsPub.WebPhoenix.Gettext
      alias CommonsPub.WebPhoenix.Router.Helpers, as: Routes

      import CommonsPub.WebPhoenixHelpers
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  defmacro __using__([which | args]) do
    apply(__MODULE__, which, args)
  end
end

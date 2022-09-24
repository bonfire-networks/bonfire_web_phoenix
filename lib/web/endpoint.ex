defmodule Bonfire.WebPhoenix.Endpoint do
  use Phoenix.Endpoint, otp_app: :bonfire_web_phoenix

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_session_key",
    signing_salt: Bonfire.Common.Config.get_ext(:bonfire_web_phoenix, :signing_salt),
    encryption_salt: Bonfire.Common.Config.get_ext(:bonfire_web_phoenix, :encryption_salt)
  ]

  socket("/socket", Bonfire.WebPhoenix.UserSocket,
    websocket: true,
    longpoll: false
  )

  socket("/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]])

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug(Plug.Static,
    at: "/",
    from: Bonfire.Common.Config.get!(:otp_app),
    gzip: false,
    only: ~w(css fonts images js favicon.ico pwa robots.txt)
  )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? and Code.ensure_loaded?(Phoenix.LiveReloader.Socket) do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)

    plug(Phoenix.Ecto.CheckRepoStatus,
      otp_app: Bonfire.Common.Config.get!(:otp_app)
    )
  end

  plug(Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"
  )

  plug(Plug.RequestId)
  plug(Plug.Telemetry, event_prefix: [:phoenix, :endpoint])

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    # Phoenix.json_library()
    json_decoder: Application.compile_env(:phoenix, :json_library)
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)
  plug(Plug.Session, @session_options)
  plug(Bonfire.WebPhoenix.Router)
end

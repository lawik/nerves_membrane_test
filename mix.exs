defmodule Foobar2.MixProject do
  use Mix.Project

  @app :foobar2
  @version "0.1.0"
  @all_targets [
    :rpi,
    :rpi0,
    :rpi2,
    :rpi3,
    :rpi3a,
    :rpi4,
    :rpi5,
    :bbb,
    :osd32mp1,
    :x86_64,
    :grisp2,
    :mangopi_mq_pro
  ]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.15",
      archives: [nerves_bootstrap: "~> 1.13"],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {Foobar2.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.10", runtime: false},
      {:shoehorn, "~> 0.9.1"},
      {:ring_logger, "~> 0.11.0"},
      {:toolshed, "~> 0.4.0"},

      # Allow Nerves.Runtime on host to support development, testing and CI.
      # See config/host.exs for usage.
      {:nerves_runtime, "~> 0.13.0"},

      # Dependencies for all targets except :host
      {:nerves_pack, "~> 0.7.1", targets: @all_targets},

      # Dependencies for specific targets
      # NOTE: It's generally low risk and recommended to follow minor version
      # bumps to Nerves systems. Since these include Linux kernel and Erlang
      # version updates, please review their release notes in case
      # changes to your application are needed.
      # {:nerves_system_rpi, "~> 1.24", runtime: false, targets: :rpi},
      # {:nerves_system_rpi0, "~> 1.24", runtime: false, targets: :rpi0},
      # {:nerves_system_rpi2, "~> 1.24", runtime: false, targets: :rpi2},
      # {:nerves_system_rpi3, "~> 1.24", runtime: false, targets: :rpi3},
      # {:nerves_system_rpi3a, "~> 1.24", runtime: false, targets: :rpi3a},
      #{:nerves_system_rpi4, "~> 1.24", runtime: false, targets: :rpi4},
      {:nerves_system_rpi4, github: "lawik/nerves_system_rpi4", branch: "membrane-media", nerves: [compile: true], runtime: false, targets: :rpi4},
      # {:nerves_system_rpi5, "~> 0.2", runtime: false, targets: :rpi5},
      # {:nerves_system_bbb, "~> 2.19", runtime: false, targets: :bbb},
      # {:nerves_system_osd32mp1, "~> 0.15", runtime: false, targets: :osd32mp1},
      # {:nerves_system_x86_64, "~> 1.24", runtime: false, targets: :x86_64},
      # {:nerves_system_grisp2, "~> 0.8", runtime: false, targets: :grisp2},
      # {:nerves_system_mangopi_mq_pro, "~> 0.6", runtime: false, targets: :mangopi_mq_pro}
      {:membrane_core, "~> 1.1"},
      {:ex_rtp, "~> 0.4.0"},
      {:ex_rtcp, "~> 0.4.0"},
      {:membrane_rtsp, "~> 0.7.0"},
      {:membrane_h26x_plugin, "~> 0.10.0"},
      {:membrane_file_plugin, "~> 0.17.0", override: true},
      {:membrane_mp4_plugin, "~> 0.35.0", override: true},
      {:membrane_http_adaptive_stream_plugin,
       github: "gBillal/membrane_http_adaptive_stream_plugin", ref: "8f75c6b"},
      {:membrane_h264_ffmpeg_plugin, "~> 0.31.0"},
      {:membrane_h265_ffmpeg_plugin, "~> 0.4.0"},
      {:membrane_ffmpeg_swscale_plugin, "~> 0.15.0"},
      {:membrane_realtimer_plugin, "~> 0.9.0"},
      {:membrane_rtc_engine, "~> 0.22.0"},
      {:membrane_rtc_engine_webrtc, "~> 0.8.0"},
      {:membrane_fake_plugin, "~> 0.11.0"},
      {:ex_libsrtp, "~> 0.7.0"},
      {:ex_m3u8, "~> 0.14.2"},
      {:ex_sdp, "~> 0.15", override: true},
      {:connection, "~> 1.1.0"},
      {:tzdata, "~> 1.1"},
      {:turbojpeg, "~> 0.4.0"},
      {:req, "~> 0.4.0"},
      {:multipart, "~> 0.4.0"},
      {:ex_mp4, "~> 0.6.0"},
      {:bundlex, "~> 1.5", override: true}
    ]
  end

  def release do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end
end

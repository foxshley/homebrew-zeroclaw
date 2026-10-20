class ZeroclawPatched < Formula
  desc "ZeroClaw with Telegram reaction and static sticker repairs"
  homepage "https://github.com/foxshley/zeroclaw"
  url "https://codeload.github.com/foxshley/zeroclaw/tar.gz/64eeebd092302095fe4b7f584296fbe88836d1fc"
  sha256 "7a8333127c13407b678f55286dc49a7a094cc1680ff683f064db57a3890cc629"
  version "0.8.6"
  revision 1
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build
  keg_only "its binaries overlap with Homebrew Core's zeroclaw package"

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "install", *std_cargo_args(path: "apps/zerocode")
    dashboard = bin/"web"/"dist"
    dashboard.mkpath
    dashboard.install Dir["web/dist/*"]
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
    keep_alive true
    log_path var/"log/zeroclaw-patched.log"
    error_log_path var/"log/zeroclaw-patched.log"
  end

  test do
    assert_match "0.8.6", shell_output("#{bin}/zeroclaw --version")
    assert_predicate bin/"zeroclaw-acp-bridge", :executable?
    assert_match "0.8.6", shell_output("#{bin}/zerocode --version")
  end

  def caveats
    <<~EOS
      This package installs the `zeroclaw` command and shares #{var}/zeroclaw
      with Homebrew Core ZeroClaw. Stop the Core service and unlink its formula
      before linking this package. Preserve the shared var directory during
      migration and rollback; it contains your existing configuration, agents,
      credentials, and memory. This package also provides the
      `zeroclaw-acp-bridge` and `zerocode` commands.

      Start with: brew services start zeroclaw-patched
      Roll back by stopping zeroclaw-patched, unlinking this package, then
      relinking and starting the still-installed Homebrew Core formula. Keep
      #{var}/zeroclaw intact.
    EOS
  end
end

class ZeroclawPatched < Formula
  desc "ZeroClaw with Telegram and delegation prompt repairs"
  homepage "https://github.com/foxshley/zeroclaw"
  url "https://github.com/foxshley/zeroclaw/archive/51d88161badfc7aa2aca665f8870037ecb73d90a.tar.gz"
  version "0.8.6"
  sha256 "45453495ad2edbb917a20db9c58844249eb0948f2f2613f4795826be43829120"
  license any_of: ["MIT", "Apache-2.0"]
  revision 5

  keg_only "its binaries overlap with Homebrew Core's zeroclaw package"

  depends_on "rust" => :build

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

  test do
    assert_match "0.8.6", shell_output("#{bin}/zeroclaw --version")
    assert_predicate bin/"zeroclaw-acp-bridge", :executable?
    assert_path_exists bin/"web/dist/index.html"
    assert_match "0.8.6", shell_output("#{bin}/zerocode --version")
  end
end

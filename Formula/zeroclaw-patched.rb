class ZeroclawPatched < Formula
  desc "Personal patched distribution of ZeroClaw"
  homepage "https://github.com/foxshley/zeroclaw"
  url "https://codeload.github.com/foxshley/zeroclaw/tar.gz/ff66e1ea60d61e64bdee38c9e1ee3af7bb9c7a9d"
  sha256 "1b2a3e15707c508b5b3982395b5ec2d337957e7eb83db0c9f38edbefc770d013"
  version "0.8.5"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build
  revision 1
  keg_only :versioned_formula

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "install", *std_cargo_args(path: "apps/zerocode")
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
      before installing this package. Preserve the shared var directory during
      migration and rollback; it contains your existing configuration, agents,
      credentials, and memory.

      Start with: brew services start zeroclaw-patched
      Roll back with: brew services stop zeroclaw-patched, then reinstall and
      relink Homebrew Core zeroclaw. Keep #{var}/zeroclaw intact.
    EOS
  end
end

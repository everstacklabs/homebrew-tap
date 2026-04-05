class Ewt < Formula
  desc "Runtime isolation for Git worktrees — run multiple environments simultaneously"
  homepage "https://ewt.sh"
  version "0.1.25"
  license "FSL-1.1-ALv2"

  on_macos do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/ewt-darwin-aarch64.tar.gz"
      sha256 "486c7ce84070ae69042b616308133674cabd5db4fe8a7f6c1c5aea6c164ba700"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/ewt-linux-aarch64.tar.gz"
      sha256 "eaf0dfd61544a80d420b13cd68c72ec03457dcc4adbabb558b382a6f9e811e4b"
    end
    on_intel do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/ewt-linux-x86_64.tar.gz"
      sha256 "750f520e8b966ba9aa5a4cb0f65c975f2bfac008a7024d198b88b5afece7e48c"
    end
  end

  def install
    bin.install "ewt"
    bin.install "ewt-daemon"

    if OS.mac?
      lib.install "libewt_remap.dylib"
      (bin/"libewt_remap.dylib").unlink if (bin/"libewt_remap.dylib").exist?
      bin.install_symlink lib/"libewt_remap.dylib"
    else
      lib.install "libewt_remap.so"
      (bin/"libewt_remap.so").unlink if (bin/"libewt_remap.so").exist?
      bin.install_symlink lib/"libewt_remap.so"
    end
  end

  def post_install
    (var/"everstack").mkpath
  end

  def caveats
    <<~EOS
      To get started:
        cd your-project
        ewt init
        ewt up

      Port isolation for linked worktrees is automatic — no setup needed.
      The port remap library (libewt_remap) is installed at:
        #{lib}/libewt_remap.#{OS.mac? ? "dylib" : "so"}
    EOS
  end

  test do
    assert_match "ewt", shell_output("#{bin}/ewt --version")
  end
end

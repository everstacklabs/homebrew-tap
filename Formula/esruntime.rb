class Esruntime < Formula
  desc "Runtime isolation for Git worktrees — run multiple environments simultaneously"
  homepage "https://runtime.everstack.ai"
  version "0.1.31"
  license "FSL-1.1-ALv2"

  on_macos do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/esruntime-darwin-aarch64.tar.gz"
      sha256 "56429d8d49d40831408b2750c8fea16e95f1be56c76181b496d0e506bbf88407"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/esruntime-linux-aarch64.tar.gz"
      sha256 "0ad7cc326baf8de4401ec170fab79593d7209d0196c2d847a7f7a2bb400fa6b7"
    end
    on_intel do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/esruntime-linux-x86_64.tar.gz"
      sha256 "7e4aa2fe614da5f54cc04c960be279f4a8e2300c4530d4e1b24578373cec87ac"
    end
  end

  def install
    bin.install "esruntime"
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
        esruntime init
        esruntime up

      Port isolation for linked worktrees is automatic — no setup needed.
      The port remap library (libewt_remap) is installed at:
        #{lib}/libewt_remap.#{OS.mac? ? "dylib" : "so"}
    EOS
  end

  test do
    assert_match "esruntime", shell_output("#{bin}/esruntime --version")
  end
end

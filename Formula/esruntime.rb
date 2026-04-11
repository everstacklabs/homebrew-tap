class Esruntime < Formula
  desc "Runtime isolation for Git worktrees — run multiple environments simultaneously"
  homepage "https://runtime.everstack.ai"
  version "0.1.32"
  license "FSL-1.1-ALv2"

  on_macos do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/esruntime-darwin-aarch64.tar.gz"
      sha256 "0327df4e56c1c0d2d646523d845a909d9572a7a11efce49ac7a4dae6d74f15d1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/esruntime-linux-aarch64.tar.gz"
      sha256 "aca4c229fed8a47b95f14a4f2b35fa703077e4c5bd18fe7442ade86fc8ca045b"
    end
    on_intel do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/esruntime-linux-x86_64.tar.gz"
      sha256 "d30000c0933ded21d9fe446536ff7f22022477b30a27572f085e85344637a621"
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

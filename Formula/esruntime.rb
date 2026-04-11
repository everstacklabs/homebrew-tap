class Esruntime < Formula
  desc "Runtime isolation for Git worktrees — run multiple environments simultaneously"
  homepage "https://runtime.everstack.ai"
  version "0.1.35"
  license "FSL-1.1-ALv2"

  on_macos do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/esruntime-darwin-aarch64.tar.gz"
      sha256 "2044732324fdbf18874f810dfb44c899042d4c31bfef68d3469f86ee1a68e945"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/esruntime-linux-aarch64.tar.gz"
      sha256 "024d32f54f0f6534641cbb49e7523be56873fa4b06ea7585c6060a805b8fe0f9"
    end
    on_intel do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/esruntime-linux-x86_64.tar.gz"
      sha256 "102be09726e9b6227b5d765156efe97ceca43019ced4e2ee45bba68adc8f7465"
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

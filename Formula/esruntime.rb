class Esruntime < Formula
  desc "Runtime isolation for Git worktrees — run multiple environments simultaneously"
  homepage "https://runtime.everstack.ai"
  version "0.1.33"
  license "FSL-1.1-ALv2"

  on_macos do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/esruntime-darwin-aarch64.tar.gz"
      sha256 "7b1061dd1eb690fc85832217d6d677c2599bad4905763285744c81d40502b156"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/esruntime-linux-aarch64.tar.gz"
      sha256 "0bad5aa488abcbd2bbdf681e13a9cd09ad6c0dd5d972b970e006d26bc2f22c46"
    end
    on_intel do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/esruntime-linux-x86_64.tar.gz"
      sha256 "96386a6c6fd6935f5ba60bf8f0418020459854ed74e12f52d5c8d4a504bee783"
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

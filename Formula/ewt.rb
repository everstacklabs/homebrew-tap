class Ewt < Formula
  desc "Runtime isolation for Git worktrees — run multiple environments simultaneously"
  homepage "https://everstack.dev/runtime"
  version "0.1.9"
  license "FSL-1.1-ALv2"

  on_macos do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/ewt-darwin-aarch64.tar.gz"
      sha256 "05d190caea44703b5f9ea5a62adcb747d6964e3c5cc621fa273df0b8bd38f340"
    end
    on_intel do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/ewt-darwin-x86_64.tar.gz"
      sha256 "0066f7480a81c92538a70d898675930c89865177cc3f4ab0ba2acd4eef9980fa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/ewt-linux-aarch64.tar.gz"
      sha256 "4ec084d7d4d2c288fb49cc924d67644afe59fba8fcc1a063295fa10ef35649eb"
    end
    on_intel do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/ewt-linux-x86_64.tar.gz"
      sha256 "f21e396da0aaffb52d3934ad83605f8e34a36745a8611dc0320fa101e43df7b7"
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

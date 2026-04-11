class Esruntime < Formula
  desc "Runtime isolation for Git worktrees — run multiple environments simultaneously"
  homepage "https://runtime.everstack.ai"
  version "0.1.34"
  license "FSL-1.1-ALv2"

  on_macos do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/esruntime-darwin-aarch64.tar.gz"
      sha256 "af1eb7cb5d1aab860f0b4b0ec72ebec7a7a31d80a59deba3c26e474ce99bd13c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/esruntime-linux-aarch64.tar.gz"
      sha256 "f8f1d45e57eb277762fa2f361a71ba814a96b57eb690d5c2e3c4a79f1d9b75a3"
    end
    on_intel do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/esruntime-linux-x86_64.tar.gz"
      sha256 "fc566781ac1b6ad12304fec29cf57bc08f628d9c95a9b8c4c82577c7bdca9908"
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

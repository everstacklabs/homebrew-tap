class Ewt < Formula
  desc "Runtime isolation for Git worktrees — run multiple environments simultaneously"
  homepage "https://everstack.dev/runtime"
  version "0.1.11"
  license "FSL-1.1-ALv2"

  on_macos do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/ewt-darwin-aarch64.tar.gz"
      sha256 "4c1422e75768964fb4d984cb04703bf2949028ba1ca52063a9d07105b4557499"
    end
    on_intel do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/ewt-darwin-x86_64.tar.gz"
      sha256 "9b33c16666036527304c76deebc7b563a6d18953125d47d748583ac62f07f795"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/ewt-linux-aarch64.tar.gz"
      sha256 "6dbe59c0841dde44afd57ab68ac97802c24d129ec69164adb0d50de64fb0bc9f"
    end
    on_intel do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/ewt-linux-x86_64.tar.gz"
      sha256 "bae314c3bef6c2c267c4e02c16c688fe3841a74493e534b8439e0078ff1077f5"
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

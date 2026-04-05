class Ewt < Formula
  desc "Runtime isolation for Git worktrees — run multiple environments simultaneously"
  homepage "https://ewt.sh"
  version "0.1.27"
  license "FSL-1.1-ALv2"

  on_macos do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/ewt-darwin-aarch64.tar.gz"
      sha256 "63fe1dc29114eba5311181f81aba3a2b2ac780aac5a11f28d329326d9dbfe57e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/ewt-linux-aarch64.tar.gz"
      sha256 "545acdb1ce7e8c28bfdb7fd8beee33c84843574266d72b80edcd971930c4afe2"
    end
    on_intel do
      url "https://github.com/everstacklabs/homebrew-tap/releases/download/v#{version}/ewt-linux-x86_64.tar.gz"
      sha256 "7767167ac642324a4caa6f0799191aa05dcdb2e76cf346bd2b641740828d6ed6"
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

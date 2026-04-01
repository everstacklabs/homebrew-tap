class Ewt < Formula
  desc "Runtime isolation for Git worktrees — run multiple environments simultaneously"
  homepage "https://everstack.dev/runtime"
  version "0.1.8"
  license "FSL-1.1-ALv2"

  on_macos do
    on_arm do
      url "https://github.com/everstacklabs/es-runtime/releases/download/v#{version}/ewt-darwin-aarch64.tar.gz"
      sha256 "08ea1f6643061b3d44ff8995630d792a369280155d1a604c411ee43b3770dd23"
    end
    on_intel do
      url "https://github.com/everstacklabs/es-runtime/releases/download/v#{version}/ewt-darwin-x86_64.tar.gz"
      sha256 "452d6a54a56194752e66a9e3011885069c38bb425fbbf0a3cc503b5fb5c586ad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/everstacklabs/es-runtime/releases/download/v#{version}/ewt-linux-aarch64.tar.gz"
      sha256 "84a135b45ba3e0e4b2caf336232138032fe9fce7d28ef7a8fbedb6ce0d4cae4f"
    end
    on_intel do
      url "https://github.com/everstacklabs/es-runtime/releases/download/v#{version}/ewt-linux-x86_64.tar.gz"
      sha256 "0ab064c3f0d5c8c928cd48cad3684dd00d6f58b37e08245ac3d146d00c51e811"
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

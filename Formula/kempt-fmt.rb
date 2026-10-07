class KemptFmt < Formula
  desc "A pre-commit-friendly multi-language formatter (ktfmt, google-java-format, license headers, whitespace)"
  homepage "https://github.com/ZacSweers/kempt"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.4.0/kempt-fmt-aarch64-apple-darwin.tar.xz"
      sha256 "cfc32615e910483849a63c1304271cb8da83716604c8a94b408a20e0203e071e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.4.0/kempt-fmt-x86_64-apple-darwin.tar.xz"
      sha256 "6c36c1b988752f09be11f67bbb6b8b7e0d356dd495c6a1b7780365ce5e8be25b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.4.0/kempt-fmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a5fa9a4229bcaf1fc8179a028aa4850679e80ee7707b2e5ccad8f9f8a19c6bbb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.4.0/kempt-fmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3e19af4cb9239c781c143ff88bf8dc9941fd245e9ff8b6c5c9dd1b1dd14bd783"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "kempt"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "kempt"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "kempt"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "kempt"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

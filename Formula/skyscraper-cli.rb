class SkyscraperCli < Formula
  desc "A CLI tool that deletes old posts from Bluesky, Mastodon, and Threads"
  homepage "https://github.com/ZacSweers/skyscraper"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.0.0/skyscraper-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9cf7f9c94ba287b2c441879b0d1a516b49fd669e63b7ac3b76cf6b5113ec3ea4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.0.0/skyscraper-cli-x86_64-apple-darwin.tar.xz"
      sha256 "dc60816aa7cc3d47b7103a00e96948fde3af23e81f18228e635b09cb47338858"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.0.0/skyscraper-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3aacb141300fa27f7ce88b4c46e8b711644eed56628ac92f378e0d53528387f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.0.0/skyscraper-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "96a439d80013efa4e87421fef0605aa938a10153625dc1dde22db64066e42e9f"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
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
    bin.install "skyscraper" if OS.mac? && Hardware::CPU.arm?
    bin.install "skyscraper" if OS.mac? && Hardware::CPU.intel?
    bin.install "skyscraper" if OS.linux? && Hardware::CPU.arm?
    bin.install "skyscraper" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

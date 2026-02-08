class SkyscraperCli < Formula
  desc "A CLI tool that deletes old posts from Bluesky and Mastodon"
  homepage "https://github.com/ZacSweers/skyscraper"
  version "1.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.2.1/skyscraper-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7c1ffebd49e199bfe62aba559c234145c68c52ce12824c3f8c191c519340e071"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.2.1/skyscraper-cli-x86_64-apple-darwin.tar.xz"
      sha256 "33920a18bf937171657eaf30c6bba55c0b32388cfb32222afd17e5cb09666f05"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.2.1/skyscraper-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9ca06d8b2b765002b43dbfb202bba5edf36f4c1d00c5c19d0bbc06014dd1ce38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.2.1/skyscraper-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7f5dce4498543cb9cf46bce9537338a83a7f5bacea614a3e501b3c8ca82f2f60"
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

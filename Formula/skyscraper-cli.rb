class SkyscraperCli < Formula
  desc "A CLI tool that deletes old posts from Bluesky and Mastodon"
  homepage "https://github.com/ZacSweers/skyscraper"
  version "1.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.3.2/skyscraper-cli-aarch64-apple-darwin.tar.xz"
      sha256 "546ed68c0f2f1e085184170c30870dbded9976d71786c024c21ec15ee2d13e8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.3.2/skyscraper-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2775c0faed86f90cf7ffcc6df6e57bf39870b369732422008c0b9ec4c32caf56"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.3.2/skyscraper-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9b1edae7d57cf3d021bbf47a436ed5884a487c6f23e947bcb3c34fa13ee65c79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.3.2/skyscraper-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c190ba6bb0d393d6544f087372f4701c9a4e0b261dd49aae8614f21cc4a23f34"
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

class SkyscraperCli < Formula
  desc "A CLI tool that deletes old posts from Bluesky and Mastodon"
  homepage "https://github.com/ZacSweers/skyscraper"
  version "1.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.3.1/skyscraper-cli-aarch64-apple-darwin.tar.xz"
      sha256 "93519e467ee18d4ed0e137b2682832243ac870c4908a812308726fc32729a7ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.3.1/skyscraper-cli-x86_64-apple-darwin.tar.xz"
      sha256 "212ae8fed1633deaf88e924db10c2e315c3332586e78bc7c75d3e71d54d01acb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.3.1/skyscraper-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "191c461416b2599fe7ecbe9eb4cda12af9847aba755dd0e4be51ebea24d33f72"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.3.1/skyscraper-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f70f953217377d685549cc8416eb3c0ea315b8c3031be2ed0467f4ddd2679dce"
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

class SkyscraperCli < Formula
  desc "A CLI tool that deletes old posts from Bluesky and Mastodon"
  homepage "https://github.com/ZacSweers/skyscraper"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.1.0/skyscraper-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ee31bfbc2a688b26afc46dcce2adc8721ad9ef46c32c4895a16a7637a1133ab6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.1.0/skyscraper-cli-x86_64-apple-darwin.tar.xz"
      sha256 "66fbeabae0b270c9c1e1930a946acb22c674e148a1c8c37c78d570c7b9416404"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.1.0/skyscraper-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a42eb2cc63a957c31574b3ddb68415da86e28d5a6bb13e72c5d9ba23ac3ded96"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.1.0/skyscraper-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3940c6c9096741e3da420bad019b16d502cd64472b01976e2ed00b35abf9094b"
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

class SkyscraperCli < Formula
  desc "A CLI tool that deletes old posts from Bluesky and Mastodon"
  homepage "https://github.com/ZacSweers/skyscraper"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.2.0/skyscraper-cli-aarch64-apple-darwin.tar.xz"
      sha256 "70dd6c40719ca5275e3b706c6c80a69ed0b1953eaf589afccfb86e54f3cb5662"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.2.0/skyscraper-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9998dbf852258adb6e241b06c6c2d37d9a212152943cf95157fd0c7493a8d4e4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.2.0/skyscraper-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "67eb1fa097d747e540630b910f19be3a4cd00a90afe3dcdc6ddb4ec6327e4a92"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/skyscraper/releases/download/v1.2.0/skyscraper-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "01a1eda66ed638589a32619a0c9f1f6ad7cba9a64e6f5c2ec09cc9202e3a7507"
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

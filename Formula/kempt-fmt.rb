class KemptFmt < Formula
  desc "A pre-commit-friendly multi-language formatter (ktfmt, google-java-format, license headers, whitespace)"
  homepage "https://github.com/ZacSweers/kempt"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.3.1/kempt-fmt-aarch64-apple-darwin.tar.xz"
      sha256 "7225b1ee8c358f66c4992452110ea82fc4a5c73db8b74c0663d1ac1631bfc216"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.3.1/kempt-fmt-x86_64-apple-darwin.tar.xz"
      sha256 "077e2b9c43bb7037aad2ce68499e020354a84516844cf4f6845c86bc336fa6ca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.3.1/kempt-fmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fda7fee9809fdd0bef3ff2d9fceac595ab62824b870b3431aba79d7258162932"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.3.1/kempt-fmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "339c06f574c03db8c45de5c1f3e15aefbafd48c886b78803f94f9b8adb7d6a01"
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
    bin.install "kempt" if OS.mac? && Hardware::CPU.arm?
    bin.install "kempt" if OS.mac? && Hardware::CPU.intel?
    bin.install "kempt" if OS.linux? && Hardware::CPU.arm?
    bin.install "kempt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

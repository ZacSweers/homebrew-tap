class Kempt < Formula
  desc "A pre-commit-friendly multi-language formatter (ktfmt, google-java-format, license headers, whitespace)"
  homepage "https://github.com/ZacSweers/kempt"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.0.2/kempt-aarch64-apple-darwin.tar.xz"
      sha256 "79efe570dd47eda55bc3760f722780087ca2d3c2ed5e32f1f4cfb7104e0385ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.0.2/kempt-x86_64-apple-darwin.tar.xz"
      sha256 "b7ebc1442268d48675755368fdb02f129dce06b31d33fe007e63ec7262505619"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.0.2/kempt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f43134804e3f3c6be42f7a8b75fa782c86176d426fe56d30f0e19a9874613187"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.0.2/kempt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e3328abd10190ef30ea012f2e022fc17276b4ad83647e758a6509166cc123fac"
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

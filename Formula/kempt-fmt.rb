class KemptFmt < Formula
  desc "A pre-commit-friendly multi-language formatter (ktfmt, google-java-format, license headers, whitespace)"
  homepage "https://github.com/ZacSweers/kempt"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.2.1/kempt-fmt-aarch64-apple-darwin.tar.xz"
      sha256 "a06a1b010d3e990dab5ff66834f5a5d65ab24050ccfe04faa59151ffc07af2c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.2.1/kempt-fmt-x86_64-apple-darwin.tar.xz"
      sha256 "44d979b50762e74795101fabff079493d598ddb9397e36c88b764d80ddcc74da"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.2.1/kempt-fmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d3c1cc39a2f52cfc5e8b9edcdf94baaae4cabff783e7150f91aafee02d39cb4f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.2.1/kempt-fmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9de751e48d5302e7cfdd77bb9aa02b7a2186de5fab058c2fbe5d800967923a40"
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

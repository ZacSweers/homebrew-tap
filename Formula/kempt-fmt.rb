class KemptFmt < Formula
  desc "A pre-commit-friendly multi-language formatter (ktfmt, google-java-format, license headers, whitespace)"
  homepage "https://github.com/ZacSweers/kempt"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.2.0/kempt-fmt-aarch64-apple-darwin.tar.xz"
      sha256 "e4987b1b5fe50fc71ecbce3ffc4763f3184d16cf2ca1be42d4a17c7386540049"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.2.0/kempt-fmt-x86_64-apple-darwin.tar.xz"
      sha256 "9455f733b0f28e82e8600839f1d20a45e639f6ad8aa2551faf12281066a027f7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.2.0/kempt-fmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "946b472f9798eb5605fe631093ba21e2114bdc7c72ff30a762415399737c9ea9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.2.0/kempt-fmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "47fdd20680d15c50f4ecaa372df1045eccd2cfbccd855f8151197e42984020df"
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

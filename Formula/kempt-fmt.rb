class KemptFmt < Formula
  desc "A pre-commit-friendly multi-language formatter (ktfmt, google-java-format, license headers, whitespace)"
  homepage "https://github.com/ZacSweers/kempt"
  version "0.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.0.4/kempt-fmt-aarch64-apple-darwin.tar.xz"
      sha256 "35040e3df1ff76c3a8e7a922e986050f3a396276c983426f8e0fa2069a9c4023"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.0.4/kempt-fmt-x86_64-apple-darwin.tar.xz"
      sha256 "a0184d50de843bc2276b723584d3d3eda18ae16f849639c16c7f621b6c1bad2b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.0.4/kempt-fmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c9d6d319a1a359a4b6d92e313f9103cb80445935086061145cd75eebbb0b2e6a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ZacSweers/kempt/releases/download/v0.0.4/kempt-fmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e436ccdaceb7aca995f467c0e1ab72741efaac3d2876fb24edc337bfafa57537"
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

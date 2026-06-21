class ElenchusCli < Formula
  desc "CLI for checking elenchus .vrf programs."
  homepage "https://github.com/m62624/elenchus"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.8.0/elenchus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "356a04127532820cda7002085e3a44b8d423635857046a80e01f583231da18a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.8.0/elenchus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7db73c2856c80f3bfde62de485dab4eecf45976ebf0c4acc396458aaf27b581c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.8.0/elenchus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3f2b751dd35e2dd3191f6bc5e3d9343136beab7fbf34e972428013d742656d7b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.8.0/elenchus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6eae211909176b2c1fe575cb286cb9eaba300550b5e2094dbc3e38c981b114a2"
    end
  end
  license "MIT"

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
    bin.install "elenchus-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "elenchus-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "elenchus-cli" if OS.linux? && Hardware::CPU.arm?
    bin.install "elenchus-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

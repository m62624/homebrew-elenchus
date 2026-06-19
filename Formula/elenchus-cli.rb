class ElenchusCli < Formula
  desc "CLI for checking elenchus .vrf programs."
  homepage "https://github.com/m62624/elenchus"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.2.0/elenchus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b9411aebc976dac40257f8e1d78eec36d63d4ab72887e5bcd3a34cb2d6116c63"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.2.0/elenchus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e01fe9f38d259aff5a1d20a53acd7e7176dc7cb7af5d3b7c3708307bf3f0973e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.2.0/elenchus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "245fbb893b12675bf39987c51b9f6ebf0d2e3e267eceb167929119351a041084"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.2.0/elenchus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f5f794580fc52ad39801e51176e96cb4e000954a00cb7e7f2d3f5ca87880013d"
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
    bin.install "elenchus" if OS.mac? && Hardware::CPU.arm?
    bin.install "elenchus" if OS.mac? && Hardware::CPU.intel?
    bin.install "elenchus" if OS.linux? && Hardware::CPU.arm?
    bin.install "elenchus" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

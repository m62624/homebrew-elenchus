class ElenchusMcp < Formula
  desc "MCP stdio server exposing elenchus checks to AI agents."
  homepage "https://github.com/m62624/elenchus"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.7.0/elenchus-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "de166a2656446ad3323469e233d039a23f0bc49c3a97b6bb31d1337f5772002f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.7.0/elenchus-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "7ef4d6279c270aeaee3f86f106619cb4fbf77c5d6e2207d86b3504ab1d1995ba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.7.0/elenchus-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f843180c2ca14a9555c2df847b0b40ac9f62b3a9278977d0a4df0e0d37557a7a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.7.0/elenchus-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5b9e8ff19bb7f67164af965eb73ba928fbfdf2756db25c8842e451c14160de60"
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
    bin.install "elenchus-mcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "elenchus-mcp" if OS.mac? && Hardware::CPU.intel?
    bin.install "elenchus-mcp" if OS.linux? && Hardware::CPU.arm?
    bin.install "elenchus-mcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

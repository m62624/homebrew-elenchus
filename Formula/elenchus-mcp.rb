class ElenchusMcp < Formula
  desc "Model Context Protocol (MCP) server for the elenchus reasoning engine: exposes an `elenchus_check` tool over stdio JSON-RPC for AI agents."
  homepage "https://github.com/m62624/elenchus"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.1.3/elenchus-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "f5e8ce7e40c0d5abe80869573d67b3671697d1e66cd7bd58d3bdf5261b583052"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.1.3/elenchus-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "c558aac0226353b0e8ee2996ef62b27e9ec110e7a0dbff513c35381e7efd14b2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.1.3/elenchus-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c2bde5e603b51cfed5ff65d335cc53f4c3b7115ee37160dd6fb6fce8ad73f7ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.1.3/elenchus-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7f718f3edb7ee7a0ede6710ae6eb6ff5b89dd03cd32979fd884f5ea69f379d04"
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

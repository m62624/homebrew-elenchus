class ElenchusMcp < Formula
  desc "MCP stdio server exposing elenchus checks to AI agents."
  homepage "https://github.com/m62624/elenchus"
  version "0.9.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.9.2/elenchus-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "965dde2e3915995ddfe6399cb3b93b843637b6409c405ed1ff0c43b5f5b999a8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.9.2/elenchus-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "315ece35ddede827e44d9b05946c3554813179d2ef8d8364669e4792d4f220b4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.9.2/elenchus-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "054e754182982f1bc16b4e3d79501d10d3084d788b3b93c78fbebb66c0c1161a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.9.2/elenchus-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bbea20240ecfe6c52ec21e783c9726c36b40bb34ef1d648f87f58262804f42e1"
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

class ElenchusMcp < Formula
  desc "MCP stdio server exposing elenchus checks to AI agents."
  homepage "https://github.com/m62624/elenchus"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.7.1/elenchus-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "83128a41e464034de62d2d91a7cd77fb78f2a897bb281fb3a4877f854be8dc5a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.7.1/elenchus-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "a29c0e8acedd78f645f788c36c9e41ba902123fa834db1c4962bd1566b16de65"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.7.1/elenchus-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5a076b031e10fc848db518976a4b09f81238a10c779775665d3356f894f18508"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.7.1/elenchus-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "947b89fdf6e5432000dbdf41419a0be428e4130aeac956d100e1242269d4a464"
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

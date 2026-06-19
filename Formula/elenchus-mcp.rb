class ElenchusMcp < Formula
  desc "MCP stdio server exposing elenchus checks to AI agents."
  homepage "https://github.com/m62624/elenchus"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.2.0/elenchus-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "fa4a3677adbe2435ed8de87417e07c98d68d2ce35770b48fc91d1ae9b3244564"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.2.0/elenchus-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "51de04a90659b422327a1d3f3efdbe8bdac554c371b43f1cc869d97f27803c5b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.2.0/elenchus-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "abc44eeebd2b4041eeb6562653d3a9e834a6a693de18991fccdf62a06414f6e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.2.0/elenchus-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "937ab8495a92ce395308055f972b8b30db3cde58dd4c6e53df6ed636b1eccbb2"
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

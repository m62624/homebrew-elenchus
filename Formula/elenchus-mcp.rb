class ElenchusMcp < Formula
  desc "MCP stdio server exposing elenchus checks to AI agents."
  homepage "https://github.com/m62624/elenchus"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.6.0/elenchus-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "6cb152b688db661ba0a5c8cde4f3c2463ed5a164f9bbccba6e00d02f0416a52a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.6.0/elenchus-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "65f527e9c0b4967c0dee2ac46d138e57228321105c79b803dba113c1034abddb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.6.0/elenchus-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bd884a711fdebd8249569415b67bdd1aa7a77b6f7a660e8ed7dba01505799b5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.6.0/elenchus-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c4e390bbf49b3175cbac4657958016cd0eead19041760fd988915fff5519f587"
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

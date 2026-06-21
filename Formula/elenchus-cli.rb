class ElenchusCli < Formula
  desc "CLI for checking elenchus .vrf programs."
  homepage "https://github.com/m62624/elenchus"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.7.0/elenchus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0f22f86f755243d5d6d1a42268c866310f717b90f24490c3b93d723a56f1e886"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.7.0/elenchus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f5c080f07364941801f6245b1aa720b3d8622fab676d8e637926b45a5b7f3480"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.7.0/elenchus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7a0e1d9cdbb69c3ee008e778d407d8ef23610b164ae894a666ec02505d888a85"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.7.0/elenchus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "818591c288e61ebcd52ff00aa73f8a86ce6fa644b0d5302d5eaa0f7b65d0228b"
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

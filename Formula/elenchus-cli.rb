class ElenchusCli < Formula
  desc "CLI for checking elenchus .vrf programs."
  homepage "https://github.com/m62624/elenchus"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.4.1/elenchus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8ec7090f40b0253c8776c36d2192e727873360087f89853e7be739ae8a269ae0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.4.1/elenchus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c7a63ab3b415659293ad4d2942322b97eccc6db99aa8d7029869bda85d8a5c3a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.4.1/elenchus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eb858199ad7e6c5f3f4d30acb04791ace947a109e45a6c39d0cc5ac755393c5d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.4.1/elenchus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0da81c45e0a28d35500c017b2d9596866f10e7880fc4d2e4ae3703dbcc4bfaeb"
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

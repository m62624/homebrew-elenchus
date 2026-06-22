class ElenchusCli < Formula
  desc "CLI for checking elenchus .vrf programs."
  homepage "https://github.com/m62624/elenchus"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.9.0/elenchus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3639d88ba5c803eca36c48198f806b81b66383cf0e58f7e157bf1aa652aa7cce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.9.0/elenchus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d223ecf9f7571085c7974864ce69a16f72cbd0eb9d520b23b02161b811caf9d9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.9.0/elenchus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "02fddc2b9fcc25405f90230aff1c1189bdf7eedda9d9518bb8b88a31dafc4944"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.9.0/elenchus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "98e12af2cf9e449799095b57195a77901fdcad1d50dceb3cd644af7049207352"
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

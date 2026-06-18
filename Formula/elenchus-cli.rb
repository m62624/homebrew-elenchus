class ElenchusCli < Formula
  desc "CLI for checking elenchus .vrf programs."
  homepage "https://github.com/m62624/elenchus"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.1.4/elenchus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3704742e76fef691dbeb19a0d544f9d407910dce72283285352469803ff36934"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.1.4/elenchus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a2fa502b77aca513b398ddb22b207dc9d68a3bc78241b010a22abe3a78771f72"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.1.4/elenchus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7b05a3a6e76b9e683c0d7278fc0a5b523a9f6b70d39ff1be7cb21da354173989"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.1.4/elenchus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a47cabf9213dcb2870a05f2394dd40eceece09e4b13c26218cbf853ffd50279"
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

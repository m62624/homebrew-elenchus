class ElenchusCli < Formula
  desc "CLI for checking elenchus .vrf programs."
  homepage "https://github.com/m62624/elenchus"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.5.0/elenchus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "919c8bbf390ff13e34ea7705746569721540667730024fdfae041601c9983f4a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.5.0/elenchus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7a378ebf5db5f03c295f26e1bb6a7c31f43862d5e3beeee4c02ffea84152f683"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.5.0/elenchus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6e682034a1b4478b59f90f7acd63738b2546c159667291ee9c65be4c874c55ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.5.0/elenchus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aa53c455c21ea378f3306e4637e95100e524be5f4574370d841c38b8eca88584"
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

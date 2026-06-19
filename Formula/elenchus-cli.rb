class ElenchusCli < Formula
  desc "CLI for checking elenchus .vrf programs."
  homepage "https://github.com/m62624/elenchus"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.4.0/elenchus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b029f9df028f29c6cfa39afb84adf073b4e5f4e07be1ae23b160a589651c4ac1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.4.0/elenchus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2a59aacaf769f14b16184f6c2dd9260e05b8f5c0cb0f943225a270e17a07de68"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.4.0/elenchus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c8131278b8c10333840fb395b2660a81f9223990796edb314107e4fe31f2e6a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.4.0/elenchus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d4cf5826ac83addfb4dddd893e79bbd1c32d5d8ccf01a242c4f3fdf562240538"
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

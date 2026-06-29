class ElenchusCli < Formula
  desc "CLI for checking elenchus .vrf programs."
  homepage "https://github.com/m62624/elenchus"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.10.0/elenchus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d7f171653264a29560daf1cbba7534185993ff5d2803bfba44a7d6adfdf86629"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.10.0/elenchus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f300a03bebe71f9428fef5fdfc4b9d4023358c1818285d153fee4b58bf37bb15"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.10.0/elenchus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "05598a01e14ef53ff9a1c2df2ab3115b75259e521b01a790b6cecc22d8d17f11"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.10.0/elenchus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0c4182f9840d5abd73a2e169b4b88dc010e58ee11692d94de1d87a9b188dce4d"
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

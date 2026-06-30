class ElenchusCli < Formula
  desc "CLI for checking elenchus .vrf programs."
  homepage "https://github.com/m62624/elenchus"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.12.0/elenchus-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4971a6e0f322468099fb0dede4f1a0d53de1e645b91db1a91b316c8fe6b795f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.12.0/elenchus-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a97839d48ac09f838160f3a54af0cff78c4b78f45ada77a18044c0cedf25c068"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/elenchus/releases/download/v0.12.0/elenchus-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b6c488d1e0f1d20a725164226ae8f16a79a185481dbef9ae63d401305e5b1cec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/elenchus/releases/download/v0.12.0/elenchus-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bf8ee5b1dc8773c329de553f4a93758f8cdef5bb892c30d0e48d333e5656a026"
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

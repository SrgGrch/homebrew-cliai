class Cliai < Formula
  desc "The cliai application"
  homepage "https://github.com/SrgGrch/CLIAI"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SrgGrch/CLIAI/releases/download/v0.1.6/cliai-aarch64-apple-darwin.tar.xz"
      sha256 "55677d0811d41a120e1c114136f8f300905a1842be467e0a45703e46d7ae1383"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SrgGrch/CLIAI/releases/download/v0.1.6/cliai-x86_64-apple-darwin.tar.xz"
      sha256 "3d6ed9e84d8cb53270602602e09d8b9945eeb5fdc5adbd4d935bb6104b89cf77"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SrgGrch/CLIAI/releases/download/v0.1.6/cliai-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e94312f934bc9a279da687f76458657bb9a04ccdc4726a9bedf51057a77e6438"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SrgGrch/CLIAI/releases/download/v0.1.6/cliai-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4cbde8b8cf7633d926a7405eb087da7ffe98742a803eef94dc2e2ad23e835b3c"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
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
    bin.install "cliai" if OS.mac? && Hardware::CPU.arm?
    bin.install "cliai" if OS.mac? && Hardware::CPU.intel?
    bin.install "cliai" if OS.linux? && Hardware::CPU.arm?
    bin.install "cliai" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

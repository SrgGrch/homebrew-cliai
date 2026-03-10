class Cliai < Formula
  desc "The cliai application"
  homepage "https://github.com/SrgGrch/CLIAI"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SrgGrch/CLIAI/releases/download/v0.1.5/cliai-aarch64-apple-darwin.tar.xz"
      sha256 "e993893fce02ea77b1bb585f490eef1ffb524d05be22edde576cb0eff49226b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SrgGrch/CLIAI/releases/download/v0.1.5/cliai-x86_64-apple-darwin.tar.xz"
      sha256 "597f77a3e1470024bf31ce8b46066f4171986914fe2517e2f28d25dee42e2931"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SrgGrch/CLIAI/releases/download/v0.1.5/cliai-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c6c8ed85c007abba05fd77e7345985fd27cd0eaed0e1372dc2bd7b647c518c4b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SrgGrch/CLIAI/releases/download/v0.1.5/cliai-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9bbdc2a3fa2d7d21fd8368c5d3f7d4b4e4cc5bd4cdb51e426eeeb76878ab5aa5"
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

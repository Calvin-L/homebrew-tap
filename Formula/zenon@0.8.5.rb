class ZenonAT085 < Formula
  desc "The Zenon theorem prover"
  homepage "https://github.com/zenon-prover/zenon"
  url "https://github.com/zenon-prover/zenon/archive/refs/tags/0.8.5.tar.gz"
  version "0.8.5"
  sha256 "73811276ad0aa46e91e346bf38937d37b1b9930e0b9f6b0aa20a5c1959e3006e"
  license "BSD3"
  revision 1

  depends_on "ocaml" => :build

  def install
    system "./configure", "--prefix", "#{prefix}"

    # NOTE (2023/7/17):  For build stability and to ensure the correct binary
    # gets installed, we need to split the build into two `make` invocations.
    # Zenon's Makefile creates the "zenon" executable depending on whether the
    # binary (.bin) or bytecode (.byt) file exists.  The default target "all"
    # will build both, but the "zenon" target only depends on the bytecode
    # file, meaning that which one gets installed as "zenon" is left up to how
    # `make` orders targets.  In a parallel build it is undefined!
    system "make", "zenon.bin"
    system "make"

    system "make", "install", "-j1"
  end

  test do
    system "zenon", "--help"
  end
end

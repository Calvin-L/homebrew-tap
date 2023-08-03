class Cvc5AT105 < Formula
  desc "Open-source automatic theorem prover"
  homepage "https://cvc5.github.io/"
  url "https://github.com/cvc5/cvc5/archive/cvc5-1.0.5.tar.gz"
  sha256 "a9705569fe36c70291dd1eb6dc5f542d33da51f82da46558e3455ed6995b1b7a"
  license "BSD-3-Clause"
  revision 3

  depends_on "antlr@3.4" => :build
  depends_on "cadical" => :build
  depends_on "cmake" => :build
  depends_on "java" => :build
  depends_on "python3-pyparsing@3.0.9" => :build
  depends_on "python3-toml@0.10.2" => :build
  depends_on "python@3.10" => :build
  depends_on "symfpu@2019.5.17" => :build # header-only library
  depends_on "gmp"
  depends_on "libantlr3c"
  depends_on "sri-csl/sri-csl/libpoly"

  def install
    system "./configure.sh", "production", "--prefix=#{prefix}"
    cd "build" do
      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"cvc5", "--version"
  end
end

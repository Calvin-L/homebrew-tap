class Cvc5AT105 < Formula
  desc "cvc5 is an open-source automatic theorem prover for Satisfiability Modulo Theories (SMT) problems."
  homepage "https://cvc5.github.io/"
  version "1.0.5"
  url "https://github.com/cvc5/cvc5/archive/cvc5-#{version}.tar.gz"
  sha256 "a9705569fe36c70291dd1eb6dc5f542d33da51f82da46558e3455ed6995b1b7a"
  license "BSD3"
  revision 2

  depends_on "cmake" => :build
  depends_on "cadical" => :build
  depends_on "python@3.10" => :build
  depends_on "python3-toml@0.10.2" => :build
  depends_on "python3-pyparsing@3.0.9" => :build
  depends_on "java" => :build
  depends_on "symfpu@2019.5.17" => :build # header-only library
  depends_on "antlr@3.4" => :build
  depends_on "libantlr3c"
  depends_on "gmp"
  depends_on "libpoly-b3a3bf82"

  def install
    system "./configure.sh", "production", "--prefix=#{prefix}"
    cd "build" do
      system "make"
      system "make", "install"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test ezpsl`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

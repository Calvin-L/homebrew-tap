class Cvc5AT009 < Formula
  desc "cvc5 is an open-source automatic theorem prover for Satisfiability Modulo Theories (SMT) problems."
  homepage "https://cvc5.github.io/"
  url "https://github.com/cvc5/cvc5/archive/cvc5-0.0.9.tar.gz"
  version "0.0.9"
  sha256 "95bcc332d8855bba2669bf73d0cbf54c5b716fa9f1867997c6589bc4acd4e65e"
  license "BSD3"
  revision 1

  depends_on "cmake" => :build
  depends_on "cadical" => :build
  depends_on "python@3" => :build
  depends_on "python3-toml@0.10.2" => :build
  depends_on "java" => :build
  depends_on "symfpu@2019.5.17" => :build # header-only library
  depends_on "antlr@3.4" => :build
  depends_on "libantlr3c"
  depends_on "gmp"

  def install
    system "./configure.sh", "production", "--no-poly", "--prefix=#{prefix}"
    cd "build" do
      system "make"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      This cvc5 package is compiled WITHOUT libpoly support, so certain
      nonlinear reasoning features might not be available.  Today (2023/4/2)
      there is no sufficiently-up-to-date package of libpoly available.  See
      https://github.com/cvc5/cvc5/issues/7993
    EOS
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

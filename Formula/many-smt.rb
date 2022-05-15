class ManySmt < Formula
  desc "Wrapper for multiple SMT solvers"
  homepage "https://github.com/Calvin-L/many-smt"
  url "https://github.com/Calvin-L/many-smt/archive/5a28ae1d48ed42e7595a2edb70779110e1069731.tar.gz"
  version "0.1"
  sha256 "ec7f8f8a84a34fe1bb1c416ae428a55c8329dfca4f2f798aaea2b25b0150d5db"
  license "MIT"

  depends_on "python@3"
  depends_on "z3" => :optional
  depends_on "cvc4/cvc4/cvc4" => :optional
  depends_on "mht208/formal/boolector" => :optional
  depends_on "sri-csl/sri-csl/yices2" => :optional

  def install
    mkdir_p bin
    cp "many-smt", bin
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

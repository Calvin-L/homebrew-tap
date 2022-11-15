class Ls4AT11 < Formula
  desc "A PLTL-prover based on labelled superposition with partial model guidance"
  homepage "https://github.com/quickbeam123/ls4"
  url "https://github.com/quickbeam123/ls4/archive/refs/tags/ls4_v1.1.tar.gz"
  version "1.1"
  sha256 "bfb0d4aa7c994cbf5e4f8c69a9c840b49c764223e078b6897592004e9a978e59"
  license "MIT"

  def install
    cd "core"
    rm "aiger.o"
    system "cc", "-Os", "-DNDEBUG", "-c", "aiger.c", "-o", "aiger.o"
    system "make", "r"
    mkdir_p "#{prefix}/bin"
    bin.install "ls4_release" => "ls4"
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

class Ls4AT11 < Formula
  desc "PLTL-prover based on labelled superposition with partial model guidance"
  homepage "https://github.com/quickbeam123/ls4"
  url "https://github.com/quickbeam123/ls4/archive/refs/tags/ls4_v1.1.tar.gz"
  sha256 "bfb0d4aa7c994cbf5e4f8c69a9c840b49c764223e078b6897592004e9a978e59"
  license "MIT"

  def install
    cd "core"
    rm "aiger.o"
    system ENV.cc, "-Os", "-DNDEBUG", "-c", "aiger.c", "-o", "aiger.o"
    system "make", "r"
    mkdir_p bin
    bin.install "ls4_release" => "ls4"
  end

  test do
    system bin/"ls4", "--help"
  end
end

class CompcertAT313 < Formula
  desc "Formally-verified C compiler"
  homepage "https://compcert.org"
  version "3.13.1"
  url "https://github.com/AbsInt/CompCert/archive/refs/tags/v#{version}.tar.gz"
  sha256 "c4314b358962240bf3e014b0caf3f7ef620a1b9a1af6abbc639a7181c3895b20"
  license "INRIA Non-Commercial"

  depends_on "coq" => :build
  depends_on "ocaml" => :build
  depends_on "menhir" => :build
  uses_from_macos "make" => :build

  def install
    system "./configure",
      "--ignore-coq-version",
      "--prefix", "#{prefix}",
      "aarch64-macos" # TODO: compute a correct target platform instead of hardcoding aarch64-macos
    system "make"
    system "make", "install", "-j1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(int argc, char** argv) {
        printf("%s\\n", "Hello, world!");
        return 0;
      }
    EOS
    system bin/"ccomp", testpath/"test.c", "-o", testpath/"test"
    system testpath/"test"
  end
end

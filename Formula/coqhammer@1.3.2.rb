class CoqhammerAT132 < Formula
  desc "An Automated Reasoning Hammer Tool for Coq"
  homepage "https://coqhammer.github.io/"
  url "https://github.com/lukaszcz/coqhammer/archive/refs/tags/v1.3.2-coq8.15.tar.gz"
  version "1.3.2"
  sha256 "d334417f5934fc222578382977e66f7eccb7f2e6b8d9f6570d5afe1a878ca70f"
  license "LGPL2"
  revision 1

  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "coq"

  def install
    system "make"
    system "make", "install",
      "COQLIBINSTALL=#{prefix}/lib/coq/user-contrib",
      "COQDOCINSTALL=#{prefix}/share/coq/user-contrib",
      "BINDIR=#{prefix}/bin"
  end

  test do
    (testpath/"Test.v").write "From Hammer Require Import Tactics."
    system "coqc", "Test.v"
  end
end

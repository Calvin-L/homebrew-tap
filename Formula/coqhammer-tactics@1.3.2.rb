class CoqhammerTacticsAT132 < Formula
  desc "An Automated Reasoning Hammer Tool for Coq"
  homepage "https://coqhammer.github.io/"
  url "https://github.com/lukaszcz/coqhammer/archive/refs/tags/v1.3.2+8.16.tar.gz"
  version "1.3.2"
  sha256 "5844ff4cd093c22f103f39407c97ef6d70cbbff6e19a19302bb908d3177e660c"
  license "LGPL2"
  revision 3

  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "coq"

  def install
    # NOTE 2023/2/2: Coq 8.16 (or maybe Homebrew's Coq?) installs lib files
    # directly to lib/ instead of lib/ocaml/ like it used to.  Ocamlfind can't
    # find things there without help.
    ENV.prepend_path "OCAMLPATH", Formula["coq"].lib

    # NOTE 2023/2/2 regarding COQPLUGININSTALL: Coq 8.16 searches for native
    # ("plugin") libraries in
    #
    #   HOMEBREW_PREFIX/lib/coq/../coq-core/..
    #
    # Unfortunately, this interacts poorly with Homebrew's symlink mechanism;
    # that path resolves to
    #
    #   HOMEBREW_PREFIX/Cellar/coq/8.16.1/lib
    #
    # In other words, we would have to install the native libraries in Coq's
    # private install folder for this to work.  Fortunately there is a
    # workaround: Coq also appears to search
    #
    #   HOMEBREW_PREFIX/lib/ocaml
    #
    # so we'll use that path.
    system "make", "tactics", "install-tactics",
      "COQLIBINSTALL=#{lib}/coq/user-contrib/",
      "COQPLUGININSTALL=#{lib}/ocaml/",
      "COQDOCINSTALL=#{share}/share/coq/user-contrib/",
      "BINDIR=#{bin}/"
  end

  def caveats
    <<~EOS
      This formula installs the CoqHammer tactics only! For functionality
      provided by the plugin, install `coqhammer` (which depends on this
      package).
    EOS
  end

  test do
    (testpath/"Test.v").write "From Hammer Require Import Tactics."
    system "coqc", "Test.v"
  end
end

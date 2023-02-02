class CoqhammerAT132 < Formula
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
  depends_on "coqhammer-tactics@1.3.2"

  def install
    # NOTE 2023/2/2: Coq 8.16 (or maybe Homebrew's Coq?) installs lib files
    # directly to lib/ instead of lib/ocaml/ like it used to.  Ocamlfind can't
    # find things there without help.
    ENV.prepend_path "OCAMLPATH", Formula["coq"].lib

    # NOTE 2023/2/2: See note in coqhammer-tactics about COQPLUGININSTALL.

    # NOTE 2023/2/2: Makefile can't find coqhammer-tactics because $PATH
    # includes
    #
    #   /opt/homebrew/opt/coq/bin
    #
    # ahead of other entries.  I guess Coq searches relative to itself to find
    # its library, and everything falls apart!  So for this build, where
    # coqc is invoked using this special path instead of
    # HOMEBREW_PREFIX/bin, we need to point Coq at the right things.
    # This path has to match COQLIBINSTALL from the coqhammer-tactics formula.
    ENV.prepend_path "COQPATH", Formula["coqhammer-tactics@1.3.2"].lib/"coq/user-contrib"

    # NOTE 2023/2/2: It seems that Coq 8.16 fully resolves its path when
    # generating makefiles, so it writes something like
    #
    #   COQMF_COQLIB=/opt/homebrew/Cellar/coq/8.16.1/lib/coq/
    #   COQMF_COQCORELIB=/opt/homebrew/Cellar/coq/8.16.1/lib/coq/../coq-core/
    #   COQMF_DOCDIR=/opt/homebrew/Cellar/coq/8.16.1/share/coq/latex/
    #
    # This is wrong---3rd party libraries are not installed to that directory,
    # only the core Coq libraries.  Homebrew symlinks everything to its own
    # prefix, e.g. /opt/homebrew/lib/coq.
    #
    # Fortunately we can override those variables during the build.
    system "make", "plugin", "install-plugin",
      "COQMF_COQLIB=#{HOMEBREW_PREFIX}/lib/coq/",
      "COQMF_COQCORELIB=#{HOMEBREW_PREFIX}/lib/coq-core/",
      "COQMF_DOCDIR=#{HOMEBREW_PREFIX}/share/coq/latex/",
      "COQLIBINSTALL=#{lib}/coq/user-contrib/",
      "COQPLUGININSTALL=#{lib}/ocaml/",
      "COQDOCINSTALL=#{share}/coq/user-contrib/",
      "BINDIR=#{bin}/"
  end

  test do
    (testpath/"Test.v").write "From Hammer Require Import Hammer."
    system "coqc", "Test.v"
  end
end

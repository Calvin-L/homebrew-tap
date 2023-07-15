class TlapsAT202210041448 < Formula
  desc "The TLA+ Proof System"
  homepage "https://tla.msr-inria.inria.fr/tlaps/"
  url "https://github.com/tlaplus/tlapm/archive/202210041448.tar.gz"
  version "202210041448"
  sha256 "c6c046f8cfc211bfee912bd6d6d736d9375411c7dad109bd3651c748e0d5550c"
  license "BSD2"
  revision 3

  depends_on "tlapm@#{version}"
  depends_on "ls4"
  depends_on "z3"
  depends_on "cvc5@1.0.5"
  # depends_on "sri-csl/sri-csl/yices2" # NOTE 2023/7/15: currently broken
  depends_on "zenon"
  depends_on "ptl-to-trp-translator"
  depends_on "isabelle@2011-1"
  depends_on "tlaps-isabelle-heap@#{version}"

  def install
    # install fake cvc4 (just a symlink to cvc5)
    mkdir_p libexec
    ln_s "#{Formula["cvc5@1.0.5"].bin}/cvc5", "#{libexec}/cvc4"

    (bin/"tlapm").write_env_script "#{Formula["tlapm"].bin}/tlapm",
        PATH: [
          "#{Formula["ls4"].bin}",
          "#{Formula["z3"].bin}",
          "#{libexec}",
          "#{Formula["zenon"].bin}",
          "#{Formula["ptl-to-trp-translator"].bin}",
          "#{Formula["isabelle@2011-1"].bin}",
          "#{HOMEBREW_PREFIX}/bin",
          "/usr/local/bin",
          "/usr/bin",
          "/bin",
        ].join(":"),
        ISABELLE_PATH: [
          "#{Formula["tlaps-isabelle-heap@#{version}"].lib}/Isabelle2011-1/heaps"
        ].join(":")
    mkdir_p "#{lib}"
    ln_s "#{Formula["tlapm"].lib}/tlaps", "#{lib}/tlaps"
  end

  def caveats
    <<~EOS
      The TLAPS library files are installed in #{lib}/tlaps/.  You probably
      want to add this path to your TLA+ module search path.

      TLAPS uses a very old version of Isabelle; this distribution does not
      include it.  Hopefully it will in the future.
    EOS
  end

  test do
    system "#{bin}/tlapm", "--config"

    (testpath/"Test.tla").write <<~EOS
      ---- MODULE Test ----

      EXTENDS Naturals, TLAPS

      THEOREM foo == 1 + 1 = 2
          OBVIOUS

      THEOREM test_isabelle == TRUE
          BY Isa

      THEOREM test_smt == TRUE
          BY SMT

      THEOREM test_zenon == TRUE
          BY Zenon

      VARIABLE x
      vars == <<x>>
      Init == x = 0
      Next == UNCHANGED x
      Spec == Init /\\ [][Next]_vars
      Inv == x = 0

      THEOREM test_ptl == Spec => []Inv
        <1>a. Init => Inv BY DEF Init, Inv
        <1>b. Inv /\\ [Next]_vars => Inv' BY DEF Next, Inv, vars
        <1> QED BY <1>a, <1>b, PTL DEF Spec

      ====
    EOS

    system "#{bin}/tlapm", testpath/"Test.tla"
  end
end

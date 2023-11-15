class TlapsAT202210041448 < Formula
  desc "TLA+ Proof System"
  homepage "https://tla.msr-inria.inria.fr/tlaps/"
  url "https://github.com/tlaplus/tlapm/archive/refs/tags/202210041448.tar.gz"
  sha256 "c6c046f8cfc211bfee912bd6d6d736d9375411c7dad109bd3651c748e0d5550c"
  license "BSD-2-Clause"
  revision 7

  depends_on "cvc5@1.0.5"
  depends_on "isabelle@2011-1"
  depends_on "ls4"
  depends_on "mht208/formal/spass"
  depends_on "mht208/formal/verit"
  depends_on "ptl-to-trp-translator"
  depends_on "sri-csl/sri-csl/yices2"
  depends_on "tlapm@202210041448"
  depends_on "tlaps-isabelle-heap@202210041448"
  depends_on "z3"
  depends_on "zenon"

  def install
    # install fake cvc4 (just a symlink to cvc5)
    mkdir_p libexec
    ln_s "#{Formula["cvc5@1.0.5"].bin}/cvc5", "#{libexec}/cvc4"

    bin_path = [
      Formula["ls4"].bin,
      Formula["z3"].bin,
      libexec,
      Formula["sri-csl/sri-csl/yices2"].bin,
      Formula["mht208/formal/verit"].bin,
      Formula["mht208/formal/spass"].bin,
      Formula["zenon"].bin,
      Formula["ptl-to-trp-translator"].bin,
      Formula["isabelle@2011-1"].bin,
      "#{HOMEBREW_PREFIX}/bin",
      "/usr/local/bin",
      "/usr/bin",
      "/bin",
    ].join(":")

    isabelle_path = [
      "#{Formula["tlaps-isabelle-heap@#{version}"].lib}/Isabelle2011-1/heaps",
    ].join(":")

    env = {
      PATH:          bin_path,
      ISABELLE_PATH: isabelle_path,
    }

    (bin/"tlapm").write_env_script "#{Formula["tlapm"].bin}/tlapm", env
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

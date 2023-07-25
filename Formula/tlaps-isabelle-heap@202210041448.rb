class TlapsIsabelleHeapAT202210041448 < Formula
  desc "TLA+ Proof System theory for Isabelle"
  homepage "https://tla.msr-inria.inria.fr/tlaps/"
  url "https://github.com/tlaplus/tlapm/archive/202210041448.tar.gz"
  sha256 "c6c046f8cfc211bfee912bd6d6d736d9375411c7dad109bd3651c748e0d5550c"
  license "BSD-2-Clause"

  depends_on "isabelle@2011-1" => :build

  def install
    system "make", "-C", "isabelle", "heap-only"
    system "find", "#{Dir.home}/.isabelle/Isabelle2011-1/heaps",
      "-type", "d",
      "-iname", "log",
      "-exec", "rm", "-r", "{}", "+"
    mkdir_p "#{lib}/Isabelle2011-1"
    mv "#{Dir.home}/.isabelle/Isabelle2011-1/heaps", "#{lib}/Isabelle2011-1/"
  end

  def caveats
    <<~EOS
      The TLAPS Isabelle heap is installed in #{lib}/Isabelle2011-1/heaps.  If
      you need to use the TLAPS Isabelle theory directly (uncommon), you will
      want to add that to $ISABELLE_PATH.
    EOS
  end

  test do
    ENV["ISABELLE_PATH"] = "#{lib}/Isabelle2011-1/heaps"
    # This line is similar to how TLAPS invokes Isabelle.
    code = '(writeln "((TLAPS SUCCESS))");'
    assert_match "((TLAPS SUCCESS))",
      shell_output("#{Formula["isabelle@2011-1"].bin}/isabelle-process -r -q -e '#{code}' TLA+")
  end
end

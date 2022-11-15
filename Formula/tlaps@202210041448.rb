class TlapsAT202210041448 < Formula
  desc "The TLA+ Proof System"
  homepage "https://tla.msr-inria.inria.fr/tlaps/"
  url "https://github.com/tlaplus/tlapm/archive/202210041448.tar.gz"
  version "202210041448"
  sha256 "c6c046f8cfc211bfee912bd6d6d736d9375411c7dad109bd3651c748e0d5550c"
  license "BSD2"

  depends_on "tlapm"
  depends_on "ls4"
  depends_on "z3"
  # depends_on "cvc4"
  depends_on "zenon"
  depends_on "ptl-to-trp-translator"

  def install
    (bin/"tlapm").write_env_script "#{HOMEBREW_PREFIX}/opt/tlapm/bin/tlapm", PATH: [
          "#{HOMEBREW_PREFIX}/opt/ls4/bin",
          "#{HOMEBREW_PREFIX}/opt/z3/bin",
          # "#{HOMEBREW_PREFIX}/opt/cvc4/bin",
          "#{HOMEBREW_PREFIX}/opt/zenon/bin",
          "#{HOMEBREW_PREFIX}/opt/ptl-to-trp-translator/bin",
          "#{HOMEBREW_PREFIX}/bin",
          "/usr/local/bin",
          "/usr/bin",
          "/bin",
        ].join(":")
    mkdir_p "#{lib}"
    ln_s "#{HOMEBREW_PREFIX}/opt/tlapm/lib/tlaps", "#{lib}/tlaps"
  end

  def caveats
    <<~EOS
      The TLAPS library files are installed in #{prefix}/lib/tlaps/.  You probably
      want to add this path to your TLA+ module search path.

      TLAPS uses a very old version of Isabelle; this distribution does not
      include it.  Hopefully it will in the future.
    EOS
  end

  test do
    system "#{bin}/tlapm", "--config"
  end
end

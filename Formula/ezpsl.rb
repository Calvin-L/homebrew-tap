class Ezpsl < Formula
  desc "Easy parallel algorithm specification language"
  homepage "https://github.com/Calvin-L/ezpsl"
  url "https://github.com/Calvin-L/ezpsl/archive/031f9679c1bc1fe9390f6601cff65e4c208ec4b5.tar.gz"
  version "0.4"
  sha256 "154489ef3c015b932d5b2c6ea8158ff6ede842fb00409d18b0c86be4d6b755e4"
  license "MIT"

  depends_on "haskell-stack" => :build

  def install
    # (install script ripped from https://github.com/Homebrew/homebrew-core/blob/57d07d4da9c972c427190b66d5fcb67714a131e7/Formula/hadolint.rb)

    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    system "stack", "-j#{jobs}", "build"
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
  end

  test do
    system "#{bin}/ezpsl", "--help"

    (testpath/"Test.tla").write <<~EOS
      ---- MODULE Test ----

      EXTENDS Integers, Sequences, TLC

      \\* #include Test.ezs

      Invariant ==
        /\\ x <= 2
        /\\ (\\A c \\in main_calls: _pc[c] = <<>>) => (x = 2)

      =====================
    EOS

    (testpath/"Test.ezs").write <<~EOS
      var x := 0;

      @entry
      proc main() {
        var tmp := x;
        yield;
        x := tmp + 1;
      }
    EOS

    system "#{bin}/ezpsl", testpath/"Test.tla"
  end
end

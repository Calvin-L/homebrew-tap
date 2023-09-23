class Caltac < Formula
  desc "Calvin's basic Coq tactics"
  homepage "https://github.com/Calvin-L/caltac"
  url "https://github.com/Calvin-L/caltac/archive/80d7f6c99ed9fe240f8099b54a8643fc37a40c94.tar.gz"
  version "0.0.1"
  sha256 "acf217678929a3ef612511a7994176122e6bfcbbde0ed8a0d23cb114b97757c0"
  license "MIT"
  revision 1

  depends_on "coq"
  depends_on "coqhammer-tactics@1.3.2"

  def install
    # See note in coqhammer formula
    ENV.prepend_path "COQPATH", Formula["coqhammer-tactics@1.3.2"].lib/"coq/user-contrib"

    system "make", "install",
      "COQLIBINSTALL=#{lib}/coq/user-contrib/",
      "COQDOCINSTALL=#{share}/share/coq/user-contrib/"
  end

  test do
    (testpath/"Test.v").write <<~EOS
      Require Import CalTac.CalTac.

      Lemma basic:
        True \\/ False.
      Proof.
        obvious.
      Qed.
    EOS
    system "coqc", "Test.v"
  end
end

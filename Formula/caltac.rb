class Caltac < Formula
  desc "Calvin's basic Coq tactics"
  homepage "https://github.com/Calvin-L/caltac"
  url "https://github.com/Calvin-L/caltac/archive/41badb91eba40638e99688adcaf05422c625e1d2.tar.gz"
  version "0.0.1"
  sha256 "87650880bda42e35df39e1e46e5dccc9fdb689a4f8f6a8e5d88d9110bd1b7e70"
  license "MIT"
  revision 3

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

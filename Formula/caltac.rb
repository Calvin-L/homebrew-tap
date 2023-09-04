class Caltac < Formula
  desc "Calvin's basic Coq tactics"
  homepage "https://github.com/Calvin-L/caltac"
  url "https://github.com/Calvin-L/caltac/archive/5858ba84284ccf2eff2bbc13e46c151995605561.tar.gz"
  version "0.0.1"
  sha256 "5e1c5a4d2ca7a50de84ad132b9c9c55001980916b2982da8d01d18280aa7304e"
  license "MIT"

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

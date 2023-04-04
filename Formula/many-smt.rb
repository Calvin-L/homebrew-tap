class ManySmt < Formula
  desc "Wrapper for multiple SMT solvers"
  homepage "https://github.com/Calvin-L/many-smt"
  url "https://github.com/Calvin-L/many-smt/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b33902cb95edb437e453c81501cd8251290a3d9b748d9d4e83a40736fde2705f"
  license "MIT"

  depends_on "python@3"
  depends_on "z3" => :recommended
  depends_on "calvin-l/tap/cvc5" => :recommended
  depends_on "mht208/formal/boolector" => :optional
  depends_on "sri-csl/sri-csl/yices2" => :optional

  def install
    mkdir_p bin
    cp "many-smt", bin
  end

  test do
    system "#{bin}/many-smt", "--info"
  end
end

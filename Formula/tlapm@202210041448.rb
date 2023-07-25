class TlapmAT202210041448 < Formula
  desc "TLA+ Proof Manager"
  homepage "https://tla.msr-inria.inria.fr/tlaps/"
  url "https://github.com/tlaplus/tlapm/archive/202210041448.tar.gz"
  sha256 "c6c046f8cfc211bfee912bd6d6d736d9375411c7dad109bd3651c748e0d5550c"
  license "BSD-2-Clause"

  keg_only "the `tlaps` package installs a `tlapm` wrapper script with better defaults"

  depends_on "ocaml" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install", "-j1"
  end

  def caveats
    <<~EOS
      You probably want to install the `tlaps` package, not this one!

      This formula only includes the `tlapm` executable.  `tlapm` discovers
      external solvers using your $PATH environment variable, so its behavior
      is quite system-dependent.  The `tlaps` package includes the default set
      of external solvers and installs a wrapper script so that `tlapm` does
      not depend so much on your environment.

      This formula exists in case you want to use the raw `tlapm` program,
      unadulterated.
    EOS
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test ezpsl`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

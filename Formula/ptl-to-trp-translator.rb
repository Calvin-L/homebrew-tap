class PtlToTrpTranslator < Formula
  desc "A translator from PTL syntax to TRP++ syntax"
  homepage "https://cgi.csc.liv.ac.uk/~konev/software/trp++/"
  url "https://cgi.csc.liv.ac.uk/%7Ekonev/software/trp++/translator/translate.tar.bz2"
  sha256 "234f5cc8e71d4575639324e84b353e129449121af4f9e62d7d51118e504ce569"
  license "GPL"
  version "0.0" # NOTE: very small project; unversioned

  depends_on "ocaml" => :build

  def install
    system "./buildAll.sh"
    bin.install "translate.bin" => "ptl_to_trp"
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

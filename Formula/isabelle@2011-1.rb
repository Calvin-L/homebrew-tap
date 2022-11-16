class IsabelleAT20111 < Formula
  desc "Isabelle is a generic proof assistant"
  homepage "https://isabelle.in.tum.de"
  url "https://isabelle.in.tum.de/website-Isabelle2011-1/dist/Isabelle2011-1.tar.gz"
  sha256 "48d77fe31a16b44f6015aa7953a60bdad8fcec9e60847630dc7b98c053edfc08"
  license "BSD3"
  version "2011-1"

  depends_on "polyml" => :build
  # depends_on "java"

  def install
    mkdir_p "#{libexec}/Isabelle2011-1"
    cp_r ".", "#{libexec}/Isabelle2011-1"
    system "#{libexec}/Isabelle2011-1/bin/isabelle", "install",
      "-d", "#{libexec}/Isabelle2011-1",
      "-p", "#{bin}"
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

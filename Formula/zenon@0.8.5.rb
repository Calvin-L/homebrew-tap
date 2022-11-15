class ZenonAT085 < Formula
  desc "The Zenon theorem prover"
  homepage "https://github.com/zenon-prover/zenon"
  url "https://github.com/zenon-prover/zenon/archive/refs/tags/0.8.5.tar.gz"
  version "0.8.5"
  sha256 "73811276ad0aa46e91e346bf38937d37b1b9930e0b9f6b0aa20a5c1959e3006e"
  license "BSD3"

  # NOTE: I wish this were a build-time-only dependency, but alas, Zenon
  # installs itself as an ocamlrun script or something.
  depends_on "ocaml"

  def install
    system "./configure", "--prefix", "#{prefix}"
    system "make"
    system "make", "install", "-j1"
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

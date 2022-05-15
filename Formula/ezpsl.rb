class Ezpsl < Formula
  desc ""
  homepage "https://github.com/Calvin-L/ezpsl"
  url "https://github.com/Calvin-L/ezpsl/archive/8557d45.tar.gz"
  version "0.3"
  sha256 "545e15355f101c0401c70d329abf3427ec65ce2cad11d122edd2f95ff361f241"
  license "MIT"

  depends_on "ghc@8.8" => :build
  depends_on "haskell-stack" => :build

  def install
    # (install script ripped from https://github.com/Homebrew/homebrew-core/blob/57d07d4da9c972c427190b66d5fcb67714a131e7/Formula/hadolint.rb)

    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    system "stack", "--system-ghc", "--compiler", "ghc-8.8", "-j#{jobs}", "build"
    system "stack", "--system-ghc", "--compiler", "ghc-8.8", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
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

class SymfpuAT2019517 < Formula
  desc "Concrete/symbolic implementation of IEEE-754/SMT-LIB floating-point"
  homepage "https://github.com/martin-cs/symfpu"
  url "https://github.com/martin-cs/symfpu/archive/8fbe139bf0071cbe0758d2f6690a546c69ff0053.tar.gz"
  version "2019.5.17"
  sha256 "da0baeefb84fb00ad44ad6993d97c2e6cc3568f9aed0d9e8693aa6b599752e5b"
  license "GPL-3.0-only"

  def install
    mkdir_p include/"symfpu"
    cp_r "core", include/"symfpu"
    cp_r "utils", include/"symfpu"
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

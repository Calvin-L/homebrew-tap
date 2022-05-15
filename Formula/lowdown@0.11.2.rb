class LowdownAT0112 < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown/"
  url "https://github.com/kristapsdz/lowdown/archive/VERSION_0_11_2.tar.gz"
  version "0.11.2"
  sha256 "96773100f5d03402c8df210a10725172515cd1c9334c7c5b6e7603e0c8810124"
  license "ISC"

  def install
    system "./configure", "PREFIX=#{prefix}"
    inreplace "Makefile", "-Wl,-soname,$@.$(LIBVER)", "-Wl,-install_name,liblowdown.1.dylib" # otherwise fails with "ld: unknown option: -soname"
    system "make"
    system "make", "install", "install_shared"
    mv lib/"liblowdown.so.1", lib/"liblowdown.1.dylib" # >:(
    ln_s lib/"liblowdown.1.dylib", lib/"liblowdown.dylib" # >:(
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

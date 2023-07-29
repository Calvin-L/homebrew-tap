class LowdownAT0112 < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown/"
  url "https://github.com/kristapsdz/lowdown/archive/VERSION_0_11_2.tar.gz"
  sha256 "96773100f5d03402c8df210a10725172515cd1c9334c7c5b6e7603e0c8810124"
  license "ISC"
  revision 1

  def install
    inreplace "configure",
      "HAVE_SANDBOX_INIT=",
      "HAVE_SANDBOX_INIT=0" # sandbox causes runtime errors (it's deprecated anyway)
    system "./configure",
      "PREFIX=#{prefix}",
      "MANDIR=#{man}" # by default, lowdown incorrectly installs to prefix/man instead of prefix/share/man
    inreplace "Makefile",
      "-Wl,-soname,$@.$(LIBVER)",
      "-Wl,-install_name,liblowdown.1.dylib" # otherwise fails with "ld: unknown option: -soname"
    system "make"
    system "make", "install", "install_shared"
    mv lib/"liblowdown.so.1", lib/"liblowdown.1.dylib" # >:(
    ln_s lib/"liblowdown.1.dylib", lib/"liblowdown.dylib" # >:(
  end

  test do
    (testpath/"test.md").write <<~EOS
      # Readme
      _text_
    EOS
    system bin/"lowdown", testpath/"test.md", "-o", testpath/"test.html"

    (testpath/"test.c").write <<~EOS
      #include <sys/queue.h>
      #include <stdio.h>
      #include <lowdown.h>

      int main(int argc, char** argv) {
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-llowdown", testpath/"test.c", "-o", testpath/"a.out"
  end
end

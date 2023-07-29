class LibeditlineAT1171 < Formula
  desc "Small replacement for GNU readline()"
  homepage "https://troglobit.com/projects/editline/"
  url "https://github.com/troglobit/editline/releases/download/1.17.1/editline-1.17.1.tar.gz"
  sha256 "781e03b6a935df75d99fb963551e2e9f09a714a8c49fc53280c716c90bf44d26"
  license "Spencer-94"
  revision 1

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <editline.h>

      int main(int argc, char** argv) {
          char *p;

          while ((p = readline("CLI> ")) != NULL) {
              puts(p);
              free(p);
          }

          return 0;
      }
    EOS

    system ENV.cc, "-I#{include}", "-L#{lib}", "-leditline", testpath/"test.c", "-o", testpath/"a.out"
  end
end

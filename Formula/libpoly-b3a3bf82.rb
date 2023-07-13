# NOTE 2023/7/13: CVC5 needs this unreleased version of libpoly.
# Adapted from https://github.com/SRI-CSL/homebrew-sri-csl/blob/933a9940fd7e339613021c56eb788650c68ead55/Formula/libpoly.rb
class LibpolyB3a3bf82 < Formula
  desc "C library for manipulating polynomials"
  homepage "https://github.com/SRI-CSL/libpoly"
  url "https://github.com/SRI-CSL/libpoly/archive/b3a3bf82.tar.gz"
  sha256 "81a8be0c632cf221c251ce0cb841acb0061201197f47e54dea5c545f8ed5546c"

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "gmp"

  def install
    cd "build" do
      system "cmake", "..",
                      "-DLIBPOLY_BUILD_PYTHON_API=OFF",
                      "-DLIBPOLY_BUILD_STATIC=OFF",
                      "-DLIBPOLY_BUILD_STATIC_PIC=OFF",
                      "-DCMAKE_BUILD_TYPE=Release",
                      "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS
    #include <poly/rational.h>
    #include <stdlib.h>

    int main(int argc, char *argv[]) {
        lp_rational_t *q;
        q = (lp_rational_t*)malloc(sizeof(lp_rational_t));
        lp_rational_construct_from_double(q, 5);
        printf("%lf", lp_rational_to_double(q));
        return 0;
    }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lpoly"
    assert_match "5.000000", shell_output("./test")
  end
end

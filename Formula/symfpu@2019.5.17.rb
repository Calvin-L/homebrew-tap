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
    (testpath/"test.cpp").write <<~EOS
      #include <symfpu/core/unpackedFloat.h>
      #include <symfpu/core/packing.h>
      #include <symfpu/core/add.h>

      int main(int argc, char** argv) {
      }
    EOS
    system ENV.cxx, "-I#{include}", testpath/"test.cpp", "-o", testpath/"a.out"
  end
end

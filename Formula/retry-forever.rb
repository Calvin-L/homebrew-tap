class RetryForever < Formula
  desc "Wrapper to retry a command forever"
  homepage "https://github.com/Calvin-L/retry-forever"
  url "https://github.com/Calvin-L/retry-forever/archive/347ea21bcc9a422b11f1c41f3d960aacd3cfd671.tar.gz"
  version "0.1"
  sha256 "75e10e57fcfd09a215eaa7b6863eec9d9705c134c610091a125a2c22a92f0a8a"
  license "MIT"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "-DCMAKE_BUILD_TYPE=MinSizeRel", "-DCMAKE_INSTALL_PREFIX=#{prefix}", ".."
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.sh").write <<~EOS
      set -ex
      #{bin}/retry-forever echo hello >#{testpath}/out &
      PID=$!
      sleep 1
      kill -TERM $PID
      wait
      fgrep -q hello #{testpath}/out
    EOS
    system "bash", testpath/"test.sh"
  end
end

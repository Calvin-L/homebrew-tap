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

class LibeditlineAT1171 < Formula
  desc "Small replacement for GNU readline()"
  homepage "https://troglobit.com/projects/editline/"
  url "https://github.com/troglobit/editline/releases/download/1.17.1/editline-1.17.1.tar.gz"
  sha256 "781e03b6a935df75d99fb963551e2e9f09a714a8c49fc53280c716c90bf44d26"
  license "Spencer-94"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
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

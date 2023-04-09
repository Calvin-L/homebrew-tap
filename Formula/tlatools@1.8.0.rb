class TlatoolsAT180 < Formula
  desc "TLA+ command line tools"
  homepage "https://lamport.azurewebsites.net/tla/tla.html"
  version "1.8.0"
  # NOTE 2022/3/31: The TLA+ build script scrapes info from the local git repo,
  # so we need to clone rather than download.
  # NOTE 2022/8/26: Version 1.8.0 tag is still in flux, so I'm pinning the
  # exact commit here.
  url "https://github.com/tlaplus/tlaplus.git", revision: "77bb1c7301d93a4f8c8dedc2b4f26f1e8843ecc2"
  license "MIT"
  revision 1

  depends_on "java"
  depends_on "ant" => :build

  def install
    cd "tlatools/org.lamport.tlatools"

    # NOTE 2020/11/17: the jar now includes the "TLC test framework", which
    # means we need to compile-test before dist.  See:
    # https://github.com/tlaplus/tlaplus/commit/f7ea7a6219f18db9f69d4a296abec597bf8264c6
    #
    # NOTE 2021/11/23: the ant build file is missing a dependency on the "info"
    # target, which generates version info that gets baked into the final jar.
    # So, we need to invoke "info" manually.
    system "ant", "-f", "customBuild.xml", "info", "compile", "compile-test", "dist"

    mkdir_p bin
    mkdir_p lib

    cp "dist/tla2tools.jar", lib

    exes = [
      ["tlc2",     "tlc2.TLC"],
      ["tlc2repl", "tlc2.REPL"],
      ["tla2sany", "tla2sany.SANY"],
      ["tla2xml",  "tla2sany.xml.XMLExporter"],
      ["pcal",     "pcal.trans"],
      ["tla2tex",  "tla2tex.TLA"]]

    for exe, cls in exes do
      (bin/exe).write("#!/bin/bash\nexec java -XX:+UseParallelGC -DTLA-Library=\"$TLA_PATH\" -cp '#{lib}/tla2tools.jar' #{cls} \"$@\"\n")
      chmod 0755, bin/exe
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    (testpath/"Test.tla").write("---- MODULE Test ----\nEXTENDS Integers\nCONSTANT MAX\nVARIABLES x\nInit == x=1\nNext == x < MAX /\\ x' = x + 1\n======\n")
    (testpath/"Test.cfg").write("CONSTANT MAX = 10\nINIT Init\nNEXT Next\n")
    system bin/"tlc2", "-deadlock", "-workers", "auto", "Test"
  end
end

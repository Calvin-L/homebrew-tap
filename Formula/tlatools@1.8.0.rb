class TlatoolsAT180 < Formula
  desc "TLA+ command-line tools"
  homepage "https://lamport.azurewebsites.net/tla/tla.html"
  # NOTE: (2022/3/31) The TLA+ build script scrapes info from the local git repo,
  # so we need to clone rather than download.
  # NOTE: (2022/8/26) Version 1.8.0 tag is still in flux, so I'm pinning the
  # exact commit here.
  url "https://github.com/tlaplus/tlaplus.git", revision: "45700fd1cc752ca9f921b33d8b3c050c737da9d8"
  version "1.8.0"
  license "MIT"
  revision 5

  depends_on "ant" => :build
  depends_on "java"

  def install
    cd "tlatools/org.lamport.tlatools"

    # NOTE: (2020/11/17) the jar now includes the "TLC test framework", which
    # means we need to compile-test before dist.  See:
    # https://github.com/tlaplus/tlaplus/commit/f7ea7a6219f18db9f69d4a296abec597bf8264c6
    #
    # NOTE: (2021/11/23) the ant build file is missing a dependency on the "info"
    # target, which generates version info that gets baked into the final jar.
    # So, we need to invoke "info" manually.
    system "ant", "-f", "customBuild.xml", "info", "compile", "compile-test", "dist"

    mkdir_p bin
    mkdir_p libexec

    cp "dist/tla2tools.jar", libexec

    exes = [
      ["tlc2",     "tlc2.TLC"],
      ["tlc2repl", "tlc2.REPL"],
      ["tla2sany", "tla2sany.SANY"],
      ["tla2xml",  "tla2sany.xml.XMLExporter"],
      ["pcal",     "pcal.trans"],
      ["tla2tex",  "tla2tex.TLA"],
    ]

    # NOTE: (2023/10/2) recommended performance flags are listed here:
    # https://github.com/tlaplus/tlaplus/blob/master/general/docs/current-tools.md
    exes.each do |exe, cls|
      script = <<~EOS
        #!/bin/bash
        exec #{Formula["java"].bin}/java -XX:+UseParallelGC -Dtlc2.tool.fp.FPSet.impl=tlc2.tool.fp.OffHeapDiskFPSet -Dtlc2.tool.ModelChecker.BAQueue=true -DTLA-Library="$TLA_PATH" -cp '#{libexec}/tla2tools.jar' #{cls} "$@"
      EOS
      (bin/exe).write script
      chmod 0755, bin/exe
    end
  end

  test do
    (testpath/"Test.tla").write <<~EOS
      ---- MODULE Test ----
      EXTENDS Integers
      CONSTANT MAX
      VARIABLES x
      Init == x=1
      Next == x < MAX /\\ x' = x + 1
      ======
    EOS
    (testpath/"Test.cfg").write <<~EOS
      CONSTANT MAX = 10
      INIT Init
      NEXT Next
    EOS
    system bin/"tlc2", "-deadlock", "-workers", "auto", "Test"
  end
end

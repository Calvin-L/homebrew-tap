class TlatoolsAT171 < Formula
  desc "TLA+ command-line tools"
  homepage "https://lamport.azurewebsites.net/tla/tla.html"
  url "https://github.com/tlaplus/tlaplus.git", revision: "v1.7.1"
  version "1.7.1"
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
      ["tla2sany", "tla2sany.SANY"],
      ["tla2xml",  "tla2sany.xml.XMLExporter"],
      ["pcal",     "pcal.trans"],
      ["tla2tex",  "tla2tex.TLA"],
    ]

    exes.each do |exe, cls|
      script = <<~EOS
        #!/bin/bash
        exec #{Formula["java"].bin}/java -XX:+UseParallelGC -DTLA-Library="$TLA_PATH" -cp '#{libexec}/tla2tools.jar' #{cls} "$@"
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

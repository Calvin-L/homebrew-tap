class AntlrAT34 < Formula
  desc "ANother Tool for Language Recognition"
  homepage "https://www.antlr.org/"
  version "3.4"
  url "https://github.com/antlr/website-antlr3/raw/gh-pages/download/antlr-#{version}-complete.jar"
  sha256 "9d3e866b610460664522520f73b81777b5626fb0a282a5952b9800b751550bf7"
  license "BSD-3-Clause"

  keg_only :versioned_formula

  livecheck do
    url "https://www.antlr.org/download.html"
    regex(/href=.*?antlr[._-]v?(\d+(?:\.\d+)+)-complete\.jar/i)
  end

  depends_on "java"
  depends_on "openjdk" => :test

  def install
    prefix.install "antlr-#{version}-complete.jar"

    (bin/"antlr").write <<~EOS
      #!/bin/bash
      CLASSPATH="#{prefix}/antlr-#{version}-complete.jar:." exec "#{Formula["java"].bin}/java" -jar #{prefix}/antlr-#{version}-complete.jar "$@"
    EOS
  end

  test do
    # https://theantlrguy.atlassian.net/wiki/spaces/ANTLR3/pages/2687299/Expression+evaluator
    path = testpath/"Expr.g"
    path.write <<~EOS
      grammar Expr;

      @header {
      import java.util.HashMap;
      }

      @members {
      /** Map variable name to Integer object holding value */
      HashMap memory = new HashMap();
      }

      prog:   stat+ ;

      stat:   expr NEWLINE {System.out.println($expr.value);}
          |   ID '=' expr NEWLINE
              {memory.put($ID.text, new Integer($expr.value));}
          |   NEWLINE
          ;

      expr returns [int value]
          :   e=multExpr {$value = $e.value;}
              (   '+' e=multExpr {$value += $e.value;}
              |   '-' e=multExpr {$value -= $e.value;}
              )*
          ;

      multExpr returns [int value]
          :   e=atom {$value = $e.value;} ('*' e=atom {$value *= $e.value;})*
          ;

      atom returns [int value]
          :   INT {$value = Integer.parseInt($INT.text);}
          |   ID
              {
              Integer v = (Integer)memory.get($ID.text);
              if ( v!=null ) $value = v.intValue();
              else System.err.println("undefined variable "+$ID.text);
              }
          |   '(' expr ')' {$value = $expr.value;}
          ;

      ID  :   ('a'..'z'|'A'..'Z')+ ;
      INT :   '0'..'9'+ ;
      NEWLINE:'\\r'? '\\n' ;
      WS  :   (' '|'\\t')+ {skip();} ;
    EOS
    system "#{bin}/antlr", "Expr.g"
    ENV["CLASSPATH"] = "#{prefix}/antlr-#{version}-complete.jar"
    system "#{Formula["openjdk"].bin}/javac", *Dir["Expr*.java"]
  end
end

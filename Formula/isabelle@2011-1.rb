class IsabelleAT20111 < Formula
  desc "Isabelle is a generic proof assistant"
  homepage "https://isabelle.in.tum.de"
  url "https://isabelle.in.tum.de/website-Isabelle#{version}/dist/Isabelle#{version}.tar.gz"
  version "2011-1"
  sha256 "48d77fe31a16b44f6015aa7953a60bdad8fcec9e60847630dc7b98c053edfc08"
  license "BSD-3-Clause"
  revision 2

  keg_only "this is a stripped-down and very old version of Isabelle (see caveats)"

  depends_on "polyml" => :build
  depends_on "java"
  depends_on "rlwrap"
  uses_from_macos "perl"

  # Lots of patches for compatibility with current PolyML (and other features).
  #  - Allow ISABELLE_PATH environment variable to point to other heaps
  #  - Remove broken code to invoke PolyML profiling
  #  - Fix broken references to PolyML library calls that have moved
  #  - Disable broken optimized SHA1 implementation
  #  - Fix int = IntInf.int assumption
  # Resources:
  #  - PolyML lib: https://www.polyml.org/documentation/Reference/PolyMLStructure.html
  #  - A relevant Isabelle-side patch: https://isabelle.in.tum.de/repos/isabelle/rev/5dc95d957569
  patch :DATA

  def install
    # Loosely based on https://github.com/tlaplus/tlapm/blob/974432f236d9e678f684288b826906ec15c1fb5c/tools/installer/tlaps-release.sh.in

    rm_r "lib/ProofGeneral"
    rm_r "doc"
    rm_r "lib/classes"
    rm_r "lib/fonts"
    rm_r "lib/logo"

    inreplace "etc/settings", "/path/to/polyml/bin", Formula["polyml"].bin
    inreplace "etc/settings", "/path/to/java/bin", Formula["java"].bin
    inreplace "etc/settings", "/path/to/rlwrap/bin", Formula["rlwrap"].bin

    system "./build", "-b", "Pure"
    mkdir_p "#{libexec}/Isabelle2011-1"
    cp_r ".", "#{libexec}/Isabelle2011-1"
    system "#{libexec}/Isabelle2011-1/bin/isabelle", "install",
      "-d", "#{libexec}/Isabelle2011-1",
      "-p", bin
  end

  def caveats
    <<~EOS
      This formula installs a stripped-down version of Isabelle that is only
      likely to be useful to the TLA+ Proof System (`tlaps` package).

      It includes the following modifications:

        - At run time, Isabelle also looks for heaps in $ISABELLE_PATH, a
          colon-separated list of directories.  Directories in $ISABELLE_PATH
          take precedence over the default search paths (~/.isabelle/Isabelle2011-1/heaps
          and #{libexec}/Isabelle2011-1/heaps).

        - Miscellaneous patches for compatibility with PolyML 5.9+.

        - Hardcoded paths to brew-installed dependencies (polyml, java, rlwrap).
    EOS
  end

  test do
    # Isabelle's braindead build script doesn't exit with an error code when it
    # fails, so this is actually a pretty important test...
    # This line is similar to how TLAPS invokes Isabelle.
    assert_match "((TLAPS SUCCESS))",
      shell_output("#{bin}/isabelle-process -r -q -e '(writeln \"((TLAPS SUCCESS))\");' Pure")
  end
end


__END__
diff --git a/etc/settings b/etc/settings
index c4bfe94..7f75f98 100644
--- a/etc/settings
+++ b/etc/settings
@@ -17,13 +17,7 @@
 
 # Poly/ML default (automated settings)
 ML_PLATFORM="$ISABELLE_PLATFORM"
-ML_HOME="$(choosefrom \
-  "$ISABELLE_HOME/contrib/polyml/$ML_PLATFORM" \
-  "$ISABELLE_HOME/../polyml/$ML_PLATFORM" \
-  "/usr/local/polyml/$ML_PLATFORM" \
-  "/usr/share/polyml/$ML_PLATFORM" \
-  "/opt/polyml/$ML_PLATFORM" \
-  "")"
+ML_HOME='/path/to/polyml/bin'
 ML_SYSTEM=$("$ISABELLE_HOME/lib/scripts/polyml-version")
 ML_OPTIONS="-H 200"
 ML_SOURCES="$ML_HOME/../src"
@@ -54,21 +48,13 @@ ML_SOURCES="$ML_HOME/../src"
 ### JVM components (Scala or Java)
 ###
 
-if [ -n "$JAVA_HOME" ]; then
-  ISABELLE_JAVA="$JAVA_HOME/bin/java"
-else
-  ISABELLE_JAVA="java"
-fi
-
+ISABELLE_JAVA="/path/to/java/bin/java"
 
 ###
 ### Interactive sessions (cf. isabelle tty)
 ###
 
-ISABELLE_LINE_EDITOR=""
-[ -z "$ISABELLE_LINE_EDITOR" ] && ISABELLE_LINE_EDITOR="$(type -p rlwrap)"
-[ -z "$ISABELLE_LINE_EDITOR" ] && ISABELLE_LINE_EDITOR="$(type -p ledit)"
-
+ISABELLE_LINE_EDITOR="/path/to/rlwrap/bin/rlwrap"
 
 ###
 ### Batch sessions (cf. isabelle usedir)
@@ -106,7 +92,7 @@ ISABELLE_TOOLS="$ISABELLE_HOME/lib/Tools"
 ISABELLE_TMP_PREFIX="/tmp/isabelle-$USER"
 
 # Heap input locations. ML system identifier is included in lookup.
-ISABELLE_PATH="$ISABELLE_HOME_USER/heaps:$ISABELLE_HOME/heaps"
+ISABELLE_PATH="$ISABELLE_PATH:$ISABELLE_HOME_USER/heaps:$ISABELLE_HOME/heaps"
 
 # Heap output location. ML system identifier is appended automatically later on.
 ISABELLE_OUTPUT="$ISABELLE_HOME_USER/heaps"
diff --git a/lib/scripts/run-polyml b/lib/scripts/run-polyml
index 4abe36f..8e875e7 100755
--- a/lib/scripts/run-polyml
+++ b/lib/scripts/run-polyml
@@ -49,7 +49,7 @@ if [ -z "$INFILE" ]; then
   EXIT="fun exit 0 = (OS.Process.exit OS.Process.success): unit | exit _ = OS.Process.exit OS.Process.failure;"
 else
   check_file "$INFILE"
-  INIT="(Signal.signal (2, Signal.SIG_HANDLE (fn _ => Process.interruptConsoleProcesses ())); PolyML.SaveState.loadState \"$INFILE\" handle Fail msg => (TextIO.output (TextIO.stdErr, msg ^ \": $INFILE\\n\"); OS.Process.exit OS.Process.failure));"
+  INIT="(Signal.signal (2, Signal.SIG_HANDLE (fn _ => Thread.Thread.broadcastInterrupt ())); PolyML.SaveState.loadState \"$INFILE\" handle Fail msg => (TextIO.output (TextIO.stdErr, msg ^ \": $INFILE\\n\"); OS.Process.exit OS.Process.failure));"
   EXIT=""
 fi
 
diff --git a/src/Pure/Concurrent/future.ML b/src/Pure/Concurrent/future.ML
index 079bc96..037ef1e 100644
--- a/src/Pure/Concurrent/future.ML
+++ b/src/Pure/Concurrent/future.ML
@@ -219,7 +219,7 @@ fun worker_exec (task, jobs) =
     val _ = Multithreading.tracing 2 (fn () =>
       let
         val s = Task_Queue.str_of_task_groups task;
-        fun micros time = string_of_int (Time.toNanoseconds time div 1000);
+        fun micros time = string_of_int (FixedInt.fromLarge (Time.toNanoseconds time div 1000));
         val (run, wait, deps) = Task_Queue.timing_of_task task;
       in "TASK " ^ s ^ " " ^ micros run ^ " " ^ micros wait ^ " (" ^ commas deps ^ ")" end);
     val _ = SYNCHRONIZED "finish" (fn () =>
diff --git a/src/Pure/General/integer.ML b/src/Pure/General/integer.ML
index 08f10bf..69ad5f0 100644
--- a/src/Pure/General/integer.ML
+++ b/src/Pure/General/integer.ML
@@ -6,27 +6,27 @@ Auxiliary operations on (unbounded) integers.
 
 signature INTEGER =
 sig
-  val min: int -> int -> int
-  val max: int -> int -> int
-  val add: int -> int -> int
-  val mult: int -> int -> int
-  val sum: int list -> int
-  val prod: int list -> int
-  val sign: int -> order
-  val div_mod: int -> int -> int * int
-  val square: int -> int
-  val pow: int -> int -> int (* exponent -> base -> result *)
-  val gcd: int -> int -> int
-  val gcds: int list -> int
-  val lcm: int -> int -> int
-  val lcms: int list -> int
+  val min: IntInf.int -> IntInf.int -> IntInf.int
+  val max: IntInf.int -> IntInf.int -> IntInf.int
+  val add: IntInf.int -> IntInf.int -> IntInf.int
+  val mult: IntInf.int -> IntInf.int -> IntInf.int
+  val sum: IntInf.int list -> IntInf.int
+  val prod: IntInf.int list -> IntInf.int
+  val sign: IntInf.int -> order
+  val div_mod: IntInf.int -> IntInf.int -> IntInf.int * IntInf.int
+  val square: IntInf.int -> IntInf.int
+  val pow: IntInf.int -> IntInf.int -> IntInf.int (* exponent -> base -> result *)
+  val gcd: IntInf.int -> IntInf.int -> IntInf.int
+  val gcds: IntInf.int list -> IntInf.int
+  val lcm: IntInf.int -> IntInf.int -> IntInf.int
+  val lcms: IntInf.int list -> IntInf.int
 end;
 
 structure Integer : INTEGER =
 struct
 
-fun min x y = Int.min (x, y);
-fun max x y = Int.max (x, y);
+fun min x y = IntInf.min (x, y);
+fun max x y = IntInf.max (x, y);
 
 fun add x y = x + y;
 fun mult x y = x * y;
@@ -34,7 +34,7 @@ fun mult x y = x * y;
 fun sum xs = fold add xs 0;
 fun prod xs = fold mult xs 1;
 
-fun sign x = int_ord (x, 0);
+fun sign x = IntInf.compare (x, 0);
 
 fun div_mod x y = IntInf.divMod (x, y);
 
diff --git a/src/Pure/General/sha1_polyml.ML b/src/Pure/General/sha1_polyml.ML
index 7d0eeaf..6010032 100644
--- a/src/Pure/General/sha1_polyml.ML
+++ b/src/Pure/General/sha1_polyml.ML
@@ -6,6 +6,7 @@ external implementation in C with a fallback to an internal
 implementation.
 *)
 
+(*
 structure SHA1: SHA1 =
 struct
 
@@ -43,3 +44,4 @@ val digest = Digest o digest_string;
 fun rep (Digest s) = s;
 
 end;
+*)
diff --git a/src/Pure/Isar/code.ML b/src/Pure/Isar/code.ML
index a623c07..25ffcf8 100644
--- a/src/Pure/Isar/code.ML
+++ b/src/Pure/Isar/code.ML
@@ -647,7 +647,7 @@ fun expand_eta thy k thm =
 fun same_arity thy thms =
   let
     val num_args_of = length o snd o strip_comb o fst o Logic.dest_equals;
-    val k = fold (Integer.max o num_args_of o Thm.prop_of) thms 0;
+    val k = fold ((fn a => fn b => FixedInt.max (a, b)) o num_args_of o Thm.prop_of) thms 0;
   in map (expand_eta thy k) thms end;
 
 fun mk_desymbolization pre post mk vs =
diff --git a/src/Pure/ML-Systems/polyml.ML b/src/Pure/ML-Systems/polyml.ML
index eabe18e..2100012 100644
--- a/src/Pure/ML-Systems/polyml.ML
+++ b/src/Pure/ML-Systems/polyml.ML
@@ -10,6 +10,14 @@ struct
   open PolyML.NameSpace;
   type T = PolyML.NameSpace.nameSpace;
   val global = PolyML.globalNameSpace;
+
+  type valueVal = Values.value;
+  type typeVal = TypeConstrs.typeConstr;
+  type fixityVal = Infixes.fixity;
+  type structureVal = Structures.structureVal;
+  type signatureVal = Signatures.signatureVal;
+  type functorVal = Functors.functorVal;
+
 end;
 
 fun reraise exn =
diff --git a/src/Pure/ML-Systems/polyml_common.ML b/src/Pure/ML-Systems/polyml_common.ML
index dfea33f..1d3d726 100644
--- a/src/Pure/ML-Systems/polyml_common.ML
+++ b/src/Pure/ML-Systems/polyml_common.ML
@@ -76,13 +76,4 @@ val ml_make_string = "PolyML.makestring";
 
 val exception_trace = PolyML.exception_trace;
 val timing = PolyML.timing;
-val profiling = PolyML.profiling;
-
-fun profile 0 f x = f x
-  | profile n f x =
-      let
-        val _ = RunCall.run_call1 RuntimeCalls.POLY_SYS_profiler n;
-        val res = Exn.capture f x;
-        val _ = RunCall.run_call1 RuntimeCalls.POLY_SYS_profiler 0;
-      in Exn.release res end;
-
+fun profile _ f = f
diff --git a/src/Pure/ML/ml_compiler_polyml-5.3.ML b/src/Pure/ML/ml_compiler_polyml-5.3.ML
index 0ee3009..baae793 100644
--- a/src/Pure/ML/ml_compiler_polyml-5.3.ML
+++ b/src/Pure/ML/ml_compiler_polyml-5.3.ML
@@ -29,6 +29,13 @@ fun exn_position exn =
 val exn_messages = Runtime.exn_messages exn_position;
 val exn_message = Runtime.exn_message exn_position;
 
+fun displayVal (x, depth, space) = PolyML.NameSpace.Values.printWithType (x, depth, SOME space);
+fun displayTypeExpression (x, depth, space) = PolyML.NameSpace.Values.printType (x, depth, SOME space);
+fun displayType (x, depth, space) = PolyML.NameSpace.TypeConstrs.print (x, depth, SOME space);
+fun displayFix (_: string, x) = PolyML.NameSpace.Infixes.print x;
+fun displayStruct (x, depth, space) = PolyML.NameSpace.Structures.print (x, depth, SOME space);
+fun displaySig (x, depth, space) = PolyML.NameSpace.Signatures.print (x, depth, SOME space);
+fun displayFunct (x, depth, space) = PolyML.NameSpace.Functors.print (x, depth, SOME space);
 
 (* parse trees *)
 
@@ -45,7 +52,7 @@ fun report_parse_tree depth space =
 
     fun reported loc (PolyML.PTtype types) =
           cons
-            (PolyML.NameSpace.displayTypeExpression (types, depth, space)
+            (displayTypeExpression (types, depth, space)
               |> pretty_ml |> Pretty.from_ML |> Pretty.string_of
               |> reported_text (position_of loc) Markup.ML_typing)
       | reported loc (PolyML.PTdeclaredAt decl) =
@@ -130,17 +137,17 @@ fun eval verbose pos toks =
           else ();
 
         fun apply_fix (a, b) =
-          (#enterFix space (a, b); display PolyML.NameSpace.displayFix (a, b));
+          (#enterFix space (a, b); display displayFix (a, b));
         fun apply_type (a, b) =
-          (#enterType space (a, b); display PolyML.NameSpace.displayType (b, depth, space));
+          (#enterType space (a, b); display displayType (b, depth, space));
         fun apply_sig (a, b) =
-          (#enterSig space (a, b); display PolyML.NameSpace.displaySig (b, depth, space));
+          (#enterSig space (a, b); display displaySig (b, depth, space));
         fun apply_struct (a, b) =
-          (#enterStruct space (a, b); display PolyML.NameSpace.displayStruct (b, depth, space));
+          (#enterStruct space (a, b); display displayStruct (b, depth, space));
         fun apply_funct (a, b) =
-          (#enterFunct space (a, b); display PolyML.NameSpace.displayFunct (b, depth, space));
+          (#enterFunct space (a, b); display displayFunct (b, depth, space));
         fun apply_val (a, b) =
-          (#enterVal space (a, b); display PolyML.NameSpace.displayVal (b, depth, space));
+          (#enterVal space (a, b); display displayVal (b, depth, space));
       in
         List.app apply_fix fixes;
         List.app apply_type types;
diff --git a/src/Pure/raw_simplifier.ML b/src/Pure/raw_simplifier.ML
index e8c6ec3..1d66131 100644
--- a/src/Pure/raw_simplifier.ML
+++ b/src/Pure/raw_simplifier.ML
@@ -1196,7 +1196,7 @@ fun bottomc ((simprem, useprem, mutsimp), prover, thy, maxidx) =
             let
               val prem' = Thm.rhs_of eqn;
               val tprems = map term_of prems;
-              val i = 1 + fold Integer.max (map (fn p =>
+              val i = 1 + fold (fn a => fn b => FixedInt.max (a, b)) (map (fn p =>
                 find_index (fn q => q aconv p) tprems) (Thm.hyps_of eqn)) ~1;
               val (rrs', asm') = rules_of_prem ss prem'
             in mut_impc prems concl rrss asms (prem' :: prems')
diff --git a/src/Pure/type_infer.ML b/src/Pure/type_infer.ML
index b8fc18c..569179a 100644
--- a/src/Pure/type_infer.ML
+++ b/src/Pure/type_infer.ML
@@ -34,7 +34,7 @@ fun is_paramT (TVar (xi, _)) = is_param xi
 
 val param_maxidx =
   (Term.fold_types o Term.fold_atyps)
-    (fn (TVar (xi as (_, i), _)) => if is_param xi then Integer.max i else I | _ => I);
+    (fn (TVar (xi as (_, i), _)) => if is_param xi then (fn x => FixedInt.max (i, x)) else I | _ => I);
 
 fun param_maxidx_of ts = fold param_maxidx ts ~1;
 
diff --git a/src/Tools/atomize_elim.ML b/src/Tools/atomize_elim.ML
index ddb515a..60d7f29 100644
--- a/src/Tools/atomize_elim.ML
+++ b/src/Tools/atomize_elim.ML
@@ -34,7 +34,7 @@ local open Conv in
 
 (* Compute inverse permutation *)
 fun invert_perm pi =
-      (pi @ subtract (op =) pi (0 upto (fold Integer.max pi 0)))
+      (pi @ subtract (op =) pi (0 upto (fold (fn a => fn b => FixedInt.max (a, b)) pi 0)))
            |> map_index I
            |> sort (int_ord o pairself snd)
            |> map fst
@@ -42,7 +42,7 @@ fun invert_perm pi =
 (* rearrange_prems as a conversion *)
 fun rearrange_prems_conv pi ct =
     let
-      val pi' = 0 :: map (Integer.add 1) pi
+      val pi' = 0 :: map (fn x => x + 1) pi
       val fwd  = Thm.trivial ct
                   |> Drule.rearrange_prems pi'
       val back = Thm.trivial (snd (Thm.dest_implies (cprop_of fwd)))

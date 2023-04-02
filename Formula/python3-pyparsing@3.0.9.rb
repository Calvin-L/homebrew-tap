class Python3PyparsingAT309 < Formula
  desc "Classes and methods to define and execute parsing grammars"
  homepage "https://github.com/pyparsing/pyparsing/"
  url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
  sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  license "MIT"
  revision 1

  depends_on "python@3.10" => [:build, :test]
  # depends_on "python@3.8" => [:build, :test]
  # depends_on "python@3.9" => [:build, :test]
  depends_on "python@3" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version)
  end

  def install
    (Pathname.pwd/"setup.py").write <<~EOS
      from setuptools import setup

      setup(name="pyparsing",
            description="#{desc}",
            version="#{version}",
      )
    EOS
    pythons.each do |python|
      system python.opt_libexec/"bin"/"python", *Language::Python.setup_install_args(prefix, python)
    end
  end

  def caveats
    python_versions = pythons.map { |p| p.version.major_minor }
                             .map(&:to_s)
                             .join(", ")

    <<~EOS
      This formula provides the `pyparsing` module for Python #{python_versions}.
      If you need `pyparsing` for a different version of Python, use pip.
    EOS
  end

  test do
    pythons.each do |python|
      system python.opt_libexec/"bin"/"python", "-c", <<~EOS
        import pyparsing
      EOS
    end
  end
end

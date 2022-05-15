class Python3TomlAT0102 < Formula
  desc "Python lib for TOML"
  homepage "https://github.com/uiri/toml"
  url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
  sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  license "MIT"

  # depends_on "python@3.10" => [:build, :test]
  # depends_on "python@3.8" => [:build, :test]
  # depends_on "python@3.9" => [:build, :test]
  depends_on "python@3" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version)
  end

  def install
    pythons.each do |python|
      system python.opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    end
  end

  def caveats
    python_versions = pythons.map { |p| p.version.major_minor }
                             .map(&:to_s)
                             .join(", ")

    <<~EOS
      This formula provides the `toml` module for Python #{python_versions}.
      If you need `toml` for a different version of Python, use pip.
    EOS
  end

  test do
    pythons.each do |python|
      system python.opt_bin/"python3", "-c", <<~EOS
        import toml
      EOS
    end
  end
end

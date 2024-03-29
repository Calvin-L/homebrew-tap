class NixAT270 < Formula
  desc "Purely functional package manager"
  homepage "https://nixos.org/"
  url "https://github.com/NixOS/nix/archive/2.7.0.tar.gz"
  sha256 "db8943317f5562f27072b39f670e6016c7fc31de15ae38a2c409c74fd1329cc9"
  license "LGPL-2.1-only"
  revision 1

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build

  depends_on "boehmgc"
  depends_on "boost"
  depends_on "brotli"
  depends_on "jq"
  depends_on "libarchive"
  depends_on "libeditline@1.17.1"
  depends_on "libsodium"
  depends_on "lowdown@0.11.2"
  depends_on "nlohmann-json"
  depends_on "openssl@1.1"
  uses_from_macos "sqlite"

  def nix_root
    "/opt/nix"
  end

  def install
    # Fix library name (or build fails with "ld: library not found for -lboost_context")
    inreplace "src/libexpr/local.mk", "-lboost_context", "-lboost_context-mt"
    inreplace "src/libutil/local.mk", "-lboost_context", "-lboost_context-mt"

    system "./bootstrap.sh"
    system "./configure",
        "--enable-gc",
        "--prefix=#{prefix}",
        "--with-store-dir=#{nix_root}/store",
        "--sharedstatedir=#{nix_root}/com",
        "--localstatedir=#{nix_root}/var",
        "--disable-doc-gen" # [1]
    system "make"
    system "make", "install", "-j1"
  end

  # [1]: otherwise it fails with "I/O error : Attempt to load network entity
  # http://docbook.org/xml/5.0/rng/docbook.rng"
  # (see https://github.com/NixOS/nix/pull/1066)

  def caveats
    <<~EOS
      You will need to create the store directories:

      sudo mkdir "#{nix_root}"
      sudo mkdir "#{nix_root}/store"
      sudo mkdir "#{nix_root}/var"
      sudo chown "$(whoami)" "#{nix_root}/store"
      sudo chown "$(whoami)" "#{nix_root}/var"

      You almost certainly want to install the configuration below,
      run `nix-env -i nss-cacert nix`, and then uninstall this package.

      ---- ~/.nixpkgs/config.nix ----
      pkgs: {
        packageOverrides = self: {
          nix = self.nix.override {
            storeDir = "#{nix_root}/store";
            stateDir = "#{nix_root}/var";
          };
        };
      }
      -------------------------------

      ---- SHELL SETUP CODE ----
      nixdir="#{nix_root}"
      export PATH="$nixdir/bin:$PATH"
      export NIX_LINK="$HOME/.nix-profile"
      export NIX_USER_PROFILE_DIR="$nixdir/var/nix/profiles/per-user/$USER"
      export PATH="$NIX_LINK/bin:$PATH"
      export NIX_SSL_CERT_FILE="$NIX_LINK/etc/ssl/certs/ca-bundle.crt"
      export NIX_PATH="$HOME/.nix-defexpr/channels"
      unset NIX_LINK NIX_USER_PROFILE_DIR
      --------------------------

      You will also want to load nixpkgs:
      `nix-channel --add https://nixos.org/channels/nixpkgs-unstable`
    EOS
  end

  test do
    system bin/"nix", "--version"
  end
end

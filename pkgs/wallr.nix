{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  llvmPackages,
  ffmpeg-full,
  libxkbcommon,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "wallr";
  version = "0.3.3-unstable-2026-08-22";

  src = fetchFromGitHub {
    owner = "programmersd21";
    repo = "wallr";
    rev = "18800d4b5f4547fc616963a2c0923744443ab5c9";
    hash = "sha256-6rwtmWntY20J/5+5YndbXYaLb9Vbc7vsV0Z9AW7vgew=";
  };

  cargoLock.lockFile = ./wallr-Cargo.lock;

  # Upstream ignores Cargo.lock even though Wallr is an application. Restore
  # the pinned lock before the Rust setup hook validates the vendored crates.
  postUnpack = ''
    cp ${./wallr-Cargo.lock} "$sourceRoot/Cargo.lock"
  '';

  nativeBuildInputs = [
    pkg-config
    llvmPackages.clang
  ];

  buildInputs = [
    ffmpeg-full
    libxkbcommon
    llvmPackages.libclang.lib
    vulkan-loader
    wayland
  ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${stdenv.cc.libc.dev}/include";

  postPatch = ''
    # Prefer the Intel iGPU for both the main renderer and per-output surfaces.
    substituteInPlace wallr-core/src/renderer/mod.rs wallr-core/src/daemon/mod.rs \
      --replace-fail 'wgpu::PowerPreference::HighPerformance' 'wgpu::PowerPreference::LowPower'

    # On this machine renderD128 is NVIDIA and renderD129 is Intel VAAPI.
    substituteInPlace wallr-core/src/video/decoder.rs \
      --replace-fail '/dev/dri/renderD128' '/dev/dri/renderD129'
  '';

  cargoBuildFlags = [
    "-p"
    "wallr"
  ];
  cargoTestFlags = [
    "-p"
    "wallr"
  ];

  meta = {
    description = "Wallpaper engine for Wayland";
    homepage = "https://github.com/programmersd21/wallr";
    license = lib.licenses.mit;
    mainProgram = "wallr";
    platforms = lib.platforms.linux;
  };
}

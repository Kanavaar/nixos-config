with import <nixpkgs> { };

mkShell {
  buildInputs = [
    linuxHeaders 
      stdenv 
      go 
      xorg.libX11 
      xorg.libXcursor 
      xorg.libXrandr
      xorg.libXfixes
      xorg.libXi
      pkg-config
      glfw
      gcc
      binutils_nogold
      xorg.libXxf86vm 
      xorg.libXinerama
  ];
}

{ stdenvNoCC
, lib
, fetchFromGitHub
, gitUpdater
, gnome-themes-extra
, gtk-engine-murrine
, jdupes
, sassc
, themeVariants ? [ "grey" ] # default: blue
, colorVariants ? [] # default: all
, sizeVariants ? [] # default: standard
, tweaks ? [ "round" ]
, icons ? [ "simple" ]
}:

let
  pname = "fluent-gtk-theme";
  version = "2022-12-15";
in

lib.checkListOfEnum "${pname}: theme variants" [ "default" "purple" "pink" "red" "orange" "yellow" "green" "teal" "grey" "all" ] themeVariants
lib.checkListOfEnum "${pname}: color variants" [ "standard" "light" "dark" ] colorVariants
lib.checkListOfEnum "${pname}: size variants" [ "standard" "compact" ] sizeVariants
lib.checkListOfEnum "${pname}: tweaks" ["solid" "float" "round" "blur" "noborder" "square"] tweaks
lib.checkListOfEnum "${pname}: icons" ["default" "apple" "simple" "gnome" "ubuntu" "arch" "manjaro" "fedora" "debian" "void" "opensuse" "popos" "mxlinux" "zorin"] icons

stdenvNoCC.mkDerivation rec {
  inherit pname;
  inherit version;

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "sha256-lGT6MIpc7cdAznZlbSJJ7aBzZPHucyfR8ZNMdJI0LP8=";
  };

  nativeBuildInputs = [
    jdupes
    sassc
  ];

  buildInputs = [
    gnome-themes-extra
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall
    patchShebangs install.sh
    name= ./install.sh \
      ${lib.optionalString (themeVariants != []) "--theme " + builtins.toString themeVariants} \
      ${lib.optionalString (colorVariants != []) "--color " + builtins.toString colorVariants} \
      ${lib.optionalString (sizeVariants != []) "--size " + builtins.toString sizeVariants} \
      ${lib.optionalString (tweaks != []) "--tweaks " + builtins.toString tweaks} \
      ${lib.optionalString (icons != []) "--icon " + builtins.toString icons} \
      --dest $out/share/themes

    jdupes --quiet --link-soft --recurse $out/share
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Fluent GTK+ theme";
    homepage = "https://github.com/vinceliuice/Fluent-gtk-theme";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.kanavaar ];
  };
}

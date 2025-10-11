# made a box64 issue https://github.com/ptitSeb/box64/issues/2478
{ inputs, self }:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.box64-binfmt;
in

with lib;
let
  box64-bleeding-edge = inputs.self.packages.${system}.box64-bleeding-edge;

  # Grouped common libraries needed for the FHS environment (64-bit ARM versions)
  steamLibs = with pkgs; [
    # unityhub
  ];
  steamLibsI686 = with pkgs.pkgsCross.gnu32; [
  ];

  steamLibsX86_64_GL = with pkgs.pkgsCross.gnu64; [
    libGL
  ];

  steamLibsX86_64 = with pkgs.pkgsCross.gnu64; [

    # Comments moved below:
    # libstdcxx5 ?
    # gcc-unwrapped.lib libgccjitga (gcc jit error)
    # libdbusmenu: causing Error: detected mismatched Qt dependencies when compiled for steamLibsI686 (maybe not)
    # sbclPackages.cl-cairo2-xlib sbcl error?
    # SDL sdl3 SDL2 sdlpop SDL_ttf SDL_net SDL_gfx (-baseqt conflict error)
    # swiftshader (CPU implementation of vulkan)
    # libcef (https://github.com/ptitSeb/box64/issues/1383) error: unsupported system i686-linux
  ];

  # Get 32-bit counterparts using armv7l cross-compilation
  # steamLibsAarch32 = let
  #   crossPkgs = pkgs.pkgsCross.armv7l-hf-multiplatform;
  #   getCrossLib = lib:
  #     let
  #       # Map problematic package names to their cross-compilation equivalents
  #       crossName =
  #         if lib.pname or null == "gtk+" then "gtk2"
  #         else if lib.pname or null == "openal-soft" then "openalSoft"
  #         else if lib.pname or null == "systemd-minimal-libs" then "systemd"
  #         else if lib.pname or null == "ibus-engines.libpinyin" then "ibus-engines"
  #         else if lib ? pname then lib.pname
  #         else lib.name;

  #       # Handle special cases where attributes need different access
  #       finalPkg = crossPkgs.${crossName} or (throw "Missing cross package: ${crossName}");
  #     in
  #     builtins.tryEval finalPkg;
  # in
  #   map (x: x.value) (filter (x: x.success) (map getCrossLib steamLibs));

  # steamLibsX86_64 = let
  #   crossPkgs = pkgs.pkgsCross.gnu64;
  #   getCrossLib = lib:
  #     let
  #       # Map problematic package names to their cross-compilation equivalents
  #       crossName =
  #         if lib.pname or null == "libdbusmenu" then "glibc"  # Skip libdbusmenu
  #         else if lib.pname or null == "qt5" then "glibc"     # Skip qt5 packages
  #         else if lib.pname or null == "gtk+-2.24.33" then "gtk2"
  #         else if lib.pname or null == "openal-soft" then "openalSoft"
  #         else if lib.pname or null == "systemd-minimal-libs" then "systemd"
  #         else if lib.pname or null == "ibus-engines.libpinyin" then "ibus-engines"
  #         else if lib ? pname then lib.pname
  #         else lib.name;

  #       # Handle special cases where attributes need different access
  #       finalPkg = crossPkgs.${crossName} or (throw "Missing cross package: ${crossName}");
  #     in
  #     builtins.tryEval finalPkg;
  # in map (x: x.value) (filter (x: x.success) (map getCrossLib steamLibs));

  # steamLibsI686 = let
  #   crossPkgs = pkgs.pkgsCross.gnu32;
  #   getCrossLib = lib:
  #     let
  #       # Expand Qt-related blocklist
  #       qtBlocklist = [
  #         "pango" "xcbutilxrm" "libappindicator" "qtsvg" "qtbase"
  #         "qtdeclarative" "qtwayland" "qt5compat" "qtgraphicaleffects"
  #       ];
  #       # Map problematic package names to their cross-compilation equivalents
  #       crossName =
  #         if lib.pname or null == "libdbusmenu" then "glibc"  # Skip libdbusmenu
  #         else if lib.pname or null == "swiftshader" then "glibc"     # Skip swiftshader packages
  #         else if lib.pname or null == "libgccjit" then "glibc"     # Skip swiftshader packages
  #         else if lib.pname or null == "qt5" then null     # Skip qt5 packages
  #         else if lib ? pname && lib.pname != "" && builtins.elem lib.pname qtBlocklist then "glibc"
  #         else if lib.pname or null == "xapp-gtk3" then "xapp-gtk3-module"
  #         else if lib.pname or null == "unity" then "libunity"
  #         else if lib.pname or null == "gtk+-2.24.33" then "gtk2"
  #         else if lib.pname or null == "openal-soft" then "openalSoft"
  #         else if lib.pname or null == "systemd-minimal-libs" then "systemd"
  #         else if lib.pname or null == "ibus-engines.libpinyin" then "ibus-engines"
  #         else if lib ? pname then lib.pname
  #         else if lib ? pname then lib.pname
  #         else lib.name;

  #       # Handle special cases where attributes need different access
  #       finalPkg = crossPkgs.${crossName} or (throw "Missing cross package: ${crossName}");
  #     in
  #     builtins.tryEval finalPkg;
  # in map (x: x.value) (filter (x: x.success) (map getCrossLib steamLibs));

  # steamLibsMineX86_64 = let
  #   crossPkgs = x86pkgs;
  #   getCrossLib = lib:
  #     let
  #       # Map problematic package names to their cross-compilation equivalents
  #       crossName =
  #         if lib.pname or null == "xapp-gtk3" then "xapp-gtk3-module"
  #         else if lib.pname or null == "unity" then "libunity"
  #         else if lib.pname or null == "gtk+-2.24.33" then "gtk2"
  #         else if lib.pname or null == "openal-soft" then "openalSoft"
  #         else if lib.pname or null == "systemd-minimal-libs" then "systemd"
  #         else if lib.pname or null == "ibus-engines.libpinyin" then "ibus-engines"
  #         else if lib ? pname then lib.pname
  #         else lib.name;

  #       # Handle special cases where attributes need different access
  #       finalPkg = crossPkgs.${crossName} or (throw "Missing cross package: ${crossName}");
  #     in
  #     builtins.tryEval finalPkg;
  # in map (x: x.value) (filter (x: x.success) (map getCrossLib steamLibs));

  # steamLibsMinei686 = let
  #   crossPkgs = pkgs.i686;
  #   getCrossLib = lib:
  #     let
  #       # Map problematic package names to their cross-compilation equivalents
  #       crossName =
  #         if lib.pname or null == "xapp-gtk3" then "xapp-gtk3-module"
  #         else if lib.pname or null == "unity" then "libunity"
  #         else if lib.pname or null == "gtk+-2.24.33" then "gtk2"
  #         else if lib.pname or null == "openal-soft" then "openalSoft"
  #         else if lib.pname or null == "systemd-minimal-libs" then "systemd"
  #         else if lib.pname or null == "ibus-engines.libpinyin" then "ibus-engines"
  #         else if lib ? pname then lib.pname
  #         else lib.name;

  #       # Handle special cases where attributes need different access
  #       finalPkg = crossPkgs.${crossName} or (throw "Missing cross package: ${crossName}");
  #     in
  #     builtins.tryEval finalPkg;
  # in map (x: x.value) (filter (x: x.success) (map getCrossLib steamLibs));

  box64Source = pkgs.fetchFromGitHub {
    owner = "ptitSeb";
    repo = "box64";
    rev = "main";
    sha256 = "sha256-V+H+DjEfX/GzQ/4eqouEu8GAe677K393PAqgEsEvhXA=";
  };
in

let
  BOX64_LOG = "1";
  BOX64_DYNAREC_LOG = "0";
  STEAMOS = "1";
  STEAM_RUNTIME = "1";
  BOX64_VARS = ''
    export BOX64_DLSYM_ERROR=1;
    export BOX64_TRANSLATE_NOWAIT=1;
    export BOX64_NOBANNER=1;
    export STEAMOS=${STEAMOS}; # https://github.com/ptitSeb/box64/issues/91#issuecomment-898858125
    export BOX64_LOG=${BOX64_LOG};
    export BOX64_DYNAREC_LOG=${BOX64_DYNAREC_LOG};
    export DBUS_FATAL_WARNINGS=1;
    export STEAM_RUNTIME=${STEAM_RUNTIME};
    export SDL_VIDEODRIVER=x11;  # wayland
    export BOX64_TRACE_FILE="stderr"; # apparantly prevents steam sniper not found error https://github.com/Botspot/pi-apps/issues/2614#issuecomment-2209629910
    export BOX86_TRACE_FILE=stderr;
    export BOX64_AVX=1;

    # https://github.com/NixOS/nixpkgs/issues/221056#issuecomment-2454222836

    # Set SwiftShader as primary
    export VULKAN_SDK="${pkgs.vulkan-headers}";
    export VK_LAYER_PATH="${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";

    # # vulkaninfo should work with CPU now, probably should remove if I MAKE THIS WORK
    # export VK_ICD_FILENAMES=${pkgs.swiftshader}/share/vulkan/icd.d/vk_swiftshader_icd.json; 
    export VK_ICD_FILENAMES=${pkgs.mesa}/share/vulkan/icd.d/lvp_icd.aarch64.json; # or radeon_icd.aarch64.json?(no)

    #export BOX64_LD_LIBRARY_PATH="${
      lib.concatMapStringsSep ":" (pkg: "${pkg}/lib") (steamLibs)
    }:$HOME/.local/share/Steam/ubuntu12_32/steam-runtime/lib/i386-linux-gnu";
    #export LD_LIBRARY_PATH="${
      lib.concatMapStringsSep ":" (pkg: "${pkg}/lib") (steamLibs)
    }:$HOME/.local/share/Steam/ubuntu12_32/steam-runtime/lib/i386-linux-gnu";
  '';

  # FHS environment that spawns a bash shell by default, or runs a given command if arguments are provided
  steamFHS = pkgs.buildFHSEnv {
    name = "steam-fhs";
    targetPkgs =
      pkgs:
      (with pkgs; [
        box64-bleeding-edge
        box86
        steam-run
        xdg-utils
        vulkan-validation-layers
        vulkan-headers
        libva-utils
        swiftshader
      ])
      ++ steamLibs;

    multiPkgs =
      pkgs: steamLibs
    # ++ steamLibsAarch32
    # ++ steamLibsX86_64 # might be good as well: https://github.com/ptitSeb/box64/issues/476#issuecomment-2667068838
    # ++ steamLibsI686 # getting the feeling that I only need these: https://github.com/ptitSeb/box64/issues/2142
    # ++ steamLibsMineX86_64
    # ++ steamLibsMinei686
    ;

    #multiArch = pkgs:
    #steamLibs
    #odbcinst
    #;

    # to know where to put the x86_64 and i368 libs:
    # I saw this comment online: (https://github.com/ptitSeb/box64/issues/476#issuecomment-2667068838)
    # ```
    # > [@michele-perrone](https://github.com/michele-perrone) You can copy x86_64 libraries to `/usr/lib/box64-x86_64-linux-gnu/` and x86 libraries to `/usr/lib/box64-i386-linux-gnu/`. Alternatively, you can use the `BOX64_LD_LIBRARY_PATH` environment variable to specify custom paths.
    # ```

    # and another comment on another issue: (https://github.com/ptitSeb/box86/issues/947#issuecomment-2022258062)
    # ```
    # > box86/box64 have a different approach compare to fex/qemu: you don't need an x86 chroot to run as it will use armhf/arm64 version of most libs directly.
    # >
    # > I suspect you are missing some arhf library, like harfbuzz.
    # >
    # > You can use `BOX86_LOG=1` for more details on missing libs when launching steam. Also, notes that gtk libs will be emulated when running steam (by design), and so will appear as missing. It's not conveniant because it makes understanding the missing what lib is missing more difficult, as some missing lib are ok, and some are not. Start by installing harfbuzz, and run with log=1 and paste the log here if it still doesn't work.
    # ```

    # makes folders /usr/lib/box64-i386-linux-gnu and /usr/lib/box64-x86_64-linux-gnu (/usr/lib is an alias to /lib64 in the FHS)
    extraBuildCommands =
      let
        # Get all store paths of the steamLibsX86_64 packages
        steamLibPaths = (builtins.map (pkg: "${pkg}") steamLibsX86_64);
      in
      ''
        mkdir -p $out/usr/lib64/box64-x86_64-linux-gnu
        cp -r ${box64Source}/x64lib/* $out/usr/lib64/box64-x86_64-linux-gnu/

        mkdir -p $out/usr/lib64/box64-i386-linux-gnu
        cp -r ${box64Source}/x86lib/* $out/usr/lib64/box64-i386-linux-gnu/

        # Symlink Steam libraries into Box64 x86_64 directory
        # TODO have to do the same with the 32 bit libs
        ${lib.concatMapStringsSep "\n" (pkgPath: ''
          # Symlink libraries from lib directory
          if [ -d "${pkgPath}/lib" ]; then
            find "${pkgPath}/lib" -maxdepth 1 -name '*.so*' -exec ln -svf -t $out/usr/lib64/box64-x86_64-linux-gnu {} \+
          fi

          # Symlink libraries from lib64 directory
          if [ -d "${pkgPath}/lib64" ]; then
            find "${pkgPath}/lib64" -maxdepth 1 -name '*.so*' -exec ln -svf -t $out/usr/lib64/box64-x86_64-linux-gnu {} \+
          fi
        '') steamLibPaths}
      '';
    runScript = ''
      # Enable box64 logging if needed
      ${BOX64_VARS}

      if [ "$#" -eq 0 ]; then
        exec ${pkgs.bashInteractive}/bin/bash
      else
        exec "$@"
      fi
    '';
  };

in
let
  box64-fhs = pkgs.writeScriptBin "box64-wrapper" ''
    #!${pkgs.bash}/bin/sh

    ${BOX64_VARS}

    exec ${steamFHS}/bin/steam-fhs ${box64-bleeding-edge}/bin/box64-bleeding-edge "$@"
  '';
in
{

  options.box64-binfmt = {
    enable = mkEnableOption "box64-binfmt";
    # binfmt.enable = mkEnableOption "box64-binfmt";
  };

  config = mkIf cfg.enable {

    # environment.sessionVariables = {
    #   LD_LIBRARY_PATH = [
    #     "${pkgs.pkgsCross.gnu32.mesa}/lib"  # x86 Mesa libraries
    #     "${pkgs.pkgsCross.gnu32.libglvnd}/lib"
    #   ];
    # };

    # Needed to allow installing x86 packages, otherwise: error: i686 Linux package set can only be used with the x86 family
    nixpkgs.overlays = [
      (
        self: super:
        let
          x86pkgs = import pkgs.path {
            system = "x86_64-linux";
            config.allowUnfree = true;
            config.allowUnsupportedSystem = true; # maybe not needed
          };
        in
        {
          inherit (x86pkgs) steam-run steam-unwrapped;
        }
      )
    ];

    # you made this comment in nixos discourse: https://discourse.nixos.org/t/how-to-install-steam-x86-64-on-a-pinephone-aarch64/19297/7?u=yeshey

    # Uncomment these lines if you need to set extra platforms for binfmt:
    # you can use qemu-x86_64 /nix/store/ar34slssgxb42jc2kzlra86ra9cz1s7f-system-path/bin/bash, to get in a shell
    #boot.binfmt.emulatedSystems = ["i686-linux" "x86_64-linux" "i386-linux" "i486-linux" "i586-linux" "i686-linux"];
    # services.qemuGuest.enable = true;

    # virtualisation.vmVariant = {
    #   # following configuration is added only when building VM with build-vm
    #   virtualisation.cores = 1;
    # };
    #virtualisation.qemu.options = [ "-display gtk,gl=on" ];

    # Ensure binfmt service is properly registered
    # boot.binfmt.registrations = {
    #   i686 = {
    #     interpreter = "${pkgs.qemu-user}/bin/qemu-i386";
    #     magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03\x00'';
    #   };
    #   x86_64 = {
    #     interpreter = "${pkgs.qemu-user}/bin/qemu-x86_64";
    #     magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
    #   };
    # };

    #security.wrappers.bwrap.setuid = lib.mkForce false;
    # security.unprivilegedUsernsClone = true;  # Still required for bwrap
    boot.binfmt.preferStaticEmulators = false; # segmentation faults everywhere! Maybe should open an issue?
    # qemu-x86_64 /nix/store/ar34slssgxb42jc2kzlra86ra9cz1s7f-system-path/bin/bash /nix/store/ar34slssgxb42jc2kzlra86ra9cz1s7f-system-path/bin/katawa-shoujo

    # qemu-x86_64 /nix/store/ar34slssgxb42jc2kzlra86ra9cz1s7f-system-path/bin/bash /nix/store/ar34slssgxb42jc2kzlra86ra9cz1s7f-system-path/bin/katawa-shoujo

    # > ls /nix/store/iibp3zwxycxkr9v9dgcs8g9jpflfbcni-qemu-user-static-aarch64-unknown-linux-musl-9.1.2/bin/                                                                                00:23:31
    # qemu-aarch64     qemu-arm    qemu-hexagon  qemu-loongarch64  qemu-microblazeel  qemu-mips64el  qemu-mipsn32el  qemu-ppc64    qemu-riscv64  qemu-sh4eb        qemu-sparc64  qemu-xtensaeb
    # qemu-aarch64_be  qemu-armeb  qemu-hppa     qemu-m68k         qemu-mips          qemu-mipsel    qemu-or1k       qemu-ppc64le  qemu-s390x    qemu-sparc        qemu-x86_64
    # qemu-alpha       qemu-cris   qemu-i386     qemu-microblaze   qemu-mips64        qemu-mipsn32   qemu-ppc        qemu-riscv32  qemu-sh4      qemu-sparc32plus  qemu-xtensa

    # nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;
    # nix.settings.extra-platforms = ["i686-linux" "x86_64-linux" "i386-linux" "i486-linux" "i586-linux" "i686-linux"];

    environment.systemPackages =
      with pkgs;
      let

        steamx86Wrapper = pkgs.writeScriptBin "box64-bashx86-steamx86-wrapper" ''
          #!${pkgs.bash}/bin/sh
          ${BOX64_VARS}

          exec ${steamFHS}/bin/steam-fhs ${box64-bleeding-edge}/bin/box64-bleeding-edge \
            ${pkgs.x86.bash}/bin/bash ${pkgs.x86.steam-unwrapped}/lib/steam/bin_steam.sh \
            -no-cef-sandbox \
            -cef-disable-gpu \
            -cef-disable-gpu-compositor \
            -system-composer \
            -srt-logger-opened \ 
            steam://open/minigameslist "$@"
        '';

        # heroicx86Wrapper = pkgs.writeScriptBin "box64-bashx86-heroicx86-wrapper" ''
        #   #!${pkgs.bash}/bin/sh
        #   ${BOX64_VARS}

        #   exec ${steamFHS}/bin/steam-fhs ${box64-bleeding-edge}/bin/box64-bleeding-edge \
        #     ${pkgs.x86.bash}/bin/bash ${pkgs.x86.heroic-unwrapped}/bin/heroic
        # '';

        # export LD_LIBRARY_PATH="${lib.makeLibraryPath steamLibsX86_64}:$LD_LIBRARY_PATH"
        glmark2-x86 = pkgs.writeShellScriptBin "glmark2-x86" ''
          export LD_LIBRARY_PATH="${lib.makeLibraryPath steamLibsX86_64_GL}:$LD_LIBRARY_PATH"
          exec /nix/store/g741bnhdizvkpqfpqnmbz4dirai1ja7s-glmark2-2023.01/bin/.glmark2-wrapped -b :show-fps=true:title=#info#
        '';

      in
      [
        # steam-related packages
        box64-fhs
        # fex # idfk man
        #steamx86
        # pkgs.x86.heroic-unwrapped
        # steamcmdx86Wrapper
        # x86pkgs.steamcmd
        # heroicx86Wrapper
        #pkgs.pkgsCross.gnu32.steam
        box64-bleeding-edge
        pkgs.x86.bash # (now this one appears with whereis bash)
        # muvm

        # qemu-user    # Explicitly include QEMU user-mode emulators
      ];

    # boot.binfmt.registrations = {
    #   i386-linux = {
    #     interpreter = "${box64-fhs}/bin/box64-wrapper";
    #     magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03\x00'';
    #     mask             = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    #   };

    #   x86_64-linux = {
    #     interpreter = "${box64-fhs}/bin/box64-wrapper";
    #     magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
    #     mask             = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    #   };
    # };

    # https://chat.deepseek.com/a/chat/s/482c6d4b-615c-43a8-98b0-e2e8e0446102
    /*
      { config, pkgs, ... }:

      let
        x86Pkgs = pkgs.pkgsCross.x86_64-linux;
        x86Config = { config, pkgs, ... }: {
          nixpkgs.system = "x86_64-linux";
          environment.systemPackages = with x86Pkgs; [
            bash
            coreutils
            # Add other packages here
          ];
        };
        x86Eval = import (pkgs.path + "/nixos/lib/eval-config.nix") {
          system = "x86_64-linux";
          modules = [ x86Config ];
        };
        x86System = x86Eval.config.system.build.toplevel;
      in

      {
        boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
        nix.settings.extra-platforms = [ "x86_64-linux" ];

        system.activationScripts.x86Chroot = ''
          mkdir -p /var/x86-chroot
          ln -sf ${x86System}/* /var/x86-chroot/
        '';

        environment.systemPackages = [
          (pkgs.writeScriptBin "enter-x86-chroot" ''
            #!/bin/sh
            CHROOT_DIR="/var/x86-chroot"
            mkdir -p $CHROOT_DIR/{proc,dev,sys}

            mount --bind /proc $CHROOT_DIR/proc
            mount --bind /dev $CHROOT_DIR/dev
            mount --bind /sys $CHROOT_DIR/sys

            exec ${pkgs.qemu}/bin/qemu-x86_64-static $CHROOT_DIR/bin/chroot $CHROOT_DIR "$@"
          '')
        ];
      }
    */

  };
}

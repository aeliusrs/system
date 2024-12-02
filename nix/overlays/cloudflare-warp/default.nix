final: prev: {
  # Remove the warp-taskbar.service file that is installed by the original package
  # This service crashes on startup and is not needed for the Warp CLI to work
  cloudflare-warp = prev.cloudflare-warp.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ prev.pkgs.installShellFiles ];
    postInstall =
      let
        bashCompletion = ./compeletion.bash;
        zshCompletion = ./compeletion.zsh;
        fishCompletion = ./compeletion.fish;
      in
      old.postInstall
      + ''

        # Disable the warp-taskbar.service file that is installed by the original package
        rm -f $out/lib/systemd/user/warp-taskbar.service

        # Install shell completions
        installShellCompletion --cmd warp-cli \
          --bash ${bashCompletion}  \
          --zsh  ${zshCompletion} \
          --fish ${fishCompletion}
      '';
  });

}

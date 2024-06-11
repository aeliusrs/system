final: prev:
{
  cloudflare-warp = prev.cloudflare-warp.overrideAttrs (old: {
    postInstall = ''
      rm -f $out/lib/systemd/user/warp-taskbar.service
    '' + old.postInstall;
  });
}

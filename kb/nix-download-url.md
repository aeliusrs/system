
download and put in the nix store:
```bash
nix-prefetch-url --unpack --print-path --name something <url>
```

put the path in a current dir to explore it:
```bash
nix-store -r /nix/store/z33ps6kl4hlpc4ddhbyh85ixxvzmzlfz-something --add-root ./result
```

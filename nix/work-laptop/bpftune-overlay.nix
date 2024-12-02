final: prev: {
  bpftune = prev.bpftune.overrideAttrs (old: {
    version = "unstable-2024-05-17";
    src = prev.fetchFromGitHub {
      owner = "oracle";
      repo = "bpftune";
      rev = "83115c56cf9620fe5669f4a3be67ab779d8f4536";
      hash = "sha256-er2i7CEUXF3BpWTG//s8C0xfIk5gSVOHB8nE1r7PX78=";
    };
  });
}

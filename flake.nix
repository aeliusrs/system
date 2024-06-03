{
  description = "My personal NixOS configuration";
  inputs = {};
  outputs = let laptop = import ./nix/work-laptop; in {
    nixosConfigurations = {
      work-laptop = laptop.nixosConfigurations.work-laptop;
    };
  };
}

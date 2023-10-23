{
  inputs = { };

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { };
    in
    {
      defaultPackage = pkgs.callPackage ./shell.nix { };
    };
}

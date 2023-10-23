## How to use direnv (locally)

First copy _.envrc_ and _shell.nix_ in target directory

`direnv allow` in target directory to enable dir specifc env

`direnv deny` in target directory to disable dir specifc env

## How to use direnv (remote)

Create _.envrc_ file and put in: `use flake "github:rstauch/nix-config?dir=direnv/java/11"`
run `direnv allow`

## Development

Change **shell.nix** and run `direnv reload`

.PHONY: update
update:
	home-manager switch --flake .#${USER}

.PHONY: clean
clean:
	nix-collect-garbage -d

.PHONY: dry-run
dry-run:
	home-manager switch --flake .#${USER} --dry-run



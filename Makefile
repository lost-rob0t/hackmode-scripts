##
# Project Title
#
# @file
# @version 0.1

.PHONY: check_deps

deps:
    @echo "Checking dependencies..."
    @command -v fzf >/dev/null 2>&1 || { echo >&2 "fzf is required but not installed. Aborting."; exit 1; }
    @command -v git >/dev/null 2>&1 || { echo >&2 "git is required but not installed. Aborting."; exit 1; }
    @command -v nix >/dev/null 2>&1 || { echo >&2 "nix is required but not installed. Aborting."; exit 1; }
    @echo "All dependencies are installed."


# end

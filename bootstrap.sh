#!/usr/bin/env bash
#
# bootstrap.sh
#
# Public laptop bootstrap launcher.
#

scriptName="$(basename "$0")";

notify() {
  >&2 echo "$(tput setaf 190)[${scriptName}]$(tput op) $*";
}

main() {
  mkdir -p "${HOME}/bootstrap";
  notify "Downloading and installing Homebrew, Dropbox, etc.";
  curl -sSfL "https://raw.githubusercontent.com/devstuff/laptop-bootstrap/brew.sh";

  notify "Installing Dropbox.";
  brew cask install dropbox;

  # shellcheck disable=SC2034
  read -r -p "Login to Dropbox, press Enter/Return when synchronization is complete." response;

  # Exec the ~/Dropbox/bootstrap-private script (private work stuff).
  "${HOME}/Dropbox/bootstrap-private";
}

main "$@";

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
  mkdir -p "${HOME}/bootstrap" && cd "${HOME}/bootstrap" && true;
  notify "Downloading and installing Homebrew, Dropbox, etc.";
  /bin/bash -c "$(curl -sSfL "https://raw.githubusercontent.com/devstuff/laptop-bootstrap/brew.sh")";

  # shellcheck disable=SC2034
  read -r -p "Login to Dropbox, press Enter/Return when synchronization is complete." response;

  # Exec the ~/Dropbox/bootstrap-private script (private work stuff).
  "${HOME}/Dropbox/bootstrap/bootstrap-private";
}

main "$@";

#!/usr/bin/env bash
#
# brew.sh
#
# Setup expected Homebrew packages.
#
# To determine what packages are installed:
#   brew list
#
# After modifying this script you must also update the global `~/.Brewfile` by
# scheduling `brewfile-update` to run on a periodic basis, or manually running:
#
#   brew bundle dump --force --describe --global
#
# shellcheck disable=SC2155
#   (see https://github.com/koalaman/shellcheck/wiki)
#

scriptName="$(basename "$0")";

notify() {
  >&2 echo "$(tput setaf 190)[${scriptName}]$(tput op) $*";
}

main() {
  # Apple command line tools can be installed with `xcode-select --install`
  notify "Agree to the XCode license.";
  sudo xcodebuild -license accept;

  if ! type -t brew; then
    >&2 echo "Downloading and installing Homebrew";
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
  fi;

  notify "Updating brew formulas...";
  brew update;

  notify "Opening taps";
  brew tap "caskroom/cask";
  brew tap "caskroom/fonts";
  brew tap "caskroom/versions";
  # brew tap "homebrew/boneyard";
  # brew tap "homebrew/completions";
  brew tap "homebrew/core";
  brew tap "homebrew/services";
  brew tap "homebrew/versions";
  brew tap "moul/moul";

  notify "Latest bash shell";
  # Use Homebrew's version of bash as the login shell.
  brew install bash;
  if ! grep "$(brew --prefix bash)/bin/bash" "/etc/shells" > /dev/null; then
    # ref: http://stackoverflow.com/a/550808
    echo "$(brew --prefix bash)/bin/bash" | sudo tee -a "/etc/shells" > /dev/null;
    chsh -s "$(brew --prefix bash)/bin/bash";
  fi;

  notify "Java JDKs";
  # The jce-unlimited-strength-policy package is no longer required as of JDK v1.8.0.161.
  # Use the AdoptOpenJDK.net builds of the JDK instead of the Oracle ones.
  brew cask install "adoptopenjdk8";

  if [[ ! -d "/usr/local/sbin" ]]; then
    >&2 echo "Your sudo password is required to create /usr/local/sbin";
    sudo mkdir -p "/usr/local/sbin";
    # "id" is the replacement for whoami (via "man whoami").
    sudo chown "$(id -un):$(id -gn)" "/usr/local/sbin";
    # shellcheck disable=SC2010
    ls -lah "/usr/local/" | grep --color=none -E 's?bin';
  fi;

  # Try to keep these lists alphabetical for easy visual search.

  notify "Primary packages";
  brew install adr-tools;
  brew install ant; # for ivycp
  brew install ammonite-repl;
  brew install asciidoc;
  brew install asdf;
  brew install awscli;
  brew install bats-core; # Shell script testing framework.
  brew install berkeley-db; # Needed for installing perl 5.26+ via perlbrew; ref: https://stackoverflow.com/a/46660972/41321
  brew install colordiff;
  brew install coreutils;
  brew install csshx;
  brew install curl --with-nghttp2;
  brew install dependency-check;
  brew install diceware;
  brew install docker;
  brew install docker-credential-helper; # for docker-credential-osxkeychain
  brew install dockutil;
  brew install enchant;
  brew install gawk;
  brew install gcviewer;
  brew install gist;
  brew install git --with-curl --with-openssl --with-perl;
  brew install git-cal;
  # brew install git-extras;
  brew install git-secrets;
  brew install gnupg;
  brew install gnupg2;
  brew install gpg-agent;
  brew install graphviz;
  brew install grc;
  brew install grep;
  brew install hadolint;
  brew install hr;
  brew install htop;
  brew install httpie;
  brew install hub;
  brew install ivy; # for ivycp
  brew install jenv; # rbenv for Java
  brew install jfrog-cli-go;
  brew install jmeter --with-plugins;
  brew install jq; # requires Java to be installed first.
  brew install less; # includes lesskey (MacOS doesn't for some weird reason)
  brew install lesspipe;
  brew install mas;
  brew install maven;
  brew install mercurial; # aka "hg".
  brew install midnight-commander;
  brew install mill;
  brew install most;
  brew install multitail;
  brew install mysql && brew services start mysql;
  brew install npm;
  brew install openssl;
  brew install p7zip;
  brew install packer;
  brew install pinentry-mac && brew linkapps pinentry-mac;
  # brew install proguard;
  brew install pstree;
  brew install python;
  brew install pwgen;
  brew install rbenv;
  brew install reattach-to-user-namespace;
  brew install rfcdiff; # required for github.com/lvc/installer-4j
  brew install safe-rm;
  brew install sbt; # requires Java to be installed first.
  brew install scala;
  brew install scalariform;
  brew install scalastyle;
  brew install sendemail;
  brew install shellcheck;
  brew install sleepwatcher; # expects /usr/local/sbin to exist, otherwise "brew link sleepwatcher" will fail.
  # brew install source-highlight; # Dependency of asciidoc.
  brew install sqlite;
  # brew install sshrc"; # https://github.com/Russell91/sshrc (now in .dotfiles, + local mods)
  brew install sshuttle; # SSH auto-VPN
  brew install terminal-notifier && brew linkapps terminal-notifier;
  brew install terraform;
  brew install tree;
  brew install wdiff; # required for github.com/lvc/installer-4j
  brew install wget;
  # brew install wrk;
  brew install xmlstarlet;

  brew install discoteq/discoteq/flock;
  brew install johanhaleby/kubetail/kubetail;
  brew install moul/moul/docker-diff;
  brew install wagoodman/dive/dive;

  notify "Command line completions";
  brew install bash-completion@2; # for Bash v4.1+
  brew install bundler-completion;
  # brew install docker-compose-completion;
  # brew install docker-machine-completion;
  brew install gem-completion;
  brew install launchctl-completion;
  brew install open-completion;
  brew install pip-completion;
  brew install rails-completion;
  brew install rake-completion;
  brew install ruby-completion;
  brew install vagrant-completion;

  notify "Fonts";
  # Hack info: https://github.com/chrissimpkins/Hack
  brew cask install font-hack;
  brew cask install font-fira-code;
  brew cask install font-inter-ui; # https://rsms.me/inter/
  brew cask install font-source-code-pro;

  notify "Other tool casks";
  brew cask install 1password;
  brew cask install --appdir="/Applications" araxis-merge;
  brew cask install authy;
  brew cask install --appdir="/Applications" bitbar;
  brew cask install --appdir="/Applications" ccmenu;
  brew cask install charles;
  brew cask install --appdir="/Applications" datadog-agent;
  brew cask install dropbox;
  brew cask install google-cloud-sdk;
  brew cask install gpg-suite;
  brew cask install jetbrains-toolbox; # Manage IntelliJ, etc.
  brew cask install key-codes;
  brew cask install minikube;
  brew cask install --appdir="/Applications" mysqlworkbench;
  brew cask install osxfuse;
  brew cask install --appdir="/Applications" paintbrush;
  brew cask install postman;
  brew cask install sqlitestudio;
  brew cask install sublime-text;
  brew cask install sublime-merge;
  brew cask install vagrant;
  brew cask install veracrypt;
  brew cask install virtualbox;
  brew cask install vlc;
  brew cask install xquartz; # Legacy X11 support.

  notify "Python packages";
  # Python packages (no need for sudo when using brewed python)
  # easy_install "pip"; # pip is preinstalled with python 2.7.9+ or 3.4+
  pip install Pygments;
  pip install json-spec;
  pip install xml2rfc; # via https://xml2rfc.tools.ietf.org/
  pip install yamllint;

  # For HTTPie (https://github.com/jkbrzt/httpie), SNI (Server Name Indication)
  # support needs updated stuff for Python versions < 2.7.9
  # sudo pip install --upgrade pyopenssl pyasn1 ndg-httpsclient;

  # The current version of the jenv formula (as at 2018-06-01) doesn't create
  # the ~/.jenv/versions folder, which is required when using "jenv add".
  mkdir -p "${HOME}/.jenv/versions";

  # If the ~/.jenv/versions folder is empty, add all of the current JDK installations into jenv.
  if [ -z "$(find "${HOME}/.jenv/versions" -mindepth 1 -print -quit 2> /dev/null)" ]; then
    while IFS= read -r -d $'\n' jdk; do
      if [ -d "${jdk}/Contents/Home/bin" ]; then
        jenv add "${jdk}/Contents/Home";
      fi;
    done < <(find /Library/Java/JavaVirtualMachines -type d -maxdepth 1 -mindepth 1 -print);
  fi;

  # Default to Java 8 (1.8) for SBT.
  if [ ! -r "${HOME}/.jenv/version" ]; then
    jenv global 1.8;
    jenv rehash;
  fi;
}

main "$@";

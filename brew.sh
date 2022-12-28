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

notice() {
  # COLUMNS is a shell variable, not exported to child processes, so use tput instead.
  # ref: http://stackoverflow.com/a/1782909/41321
  local cols=$(tput cols);
  local len=${#1};
  local prefix="[${scriptName}]";
  local prefixLen=${#prefix};
  local rem=$((${cols:-79}-len-prefixLen-2)); # 2 => spaces.
  local rhs="$(printf "%${rem}s" '' | tr ' ' '=')";
  # 13 is bright yellow green.
  echo "$(tput setaf 13)${prefix}$(tput sgr0) $1 $(tput setaf 13)${rhs}$(tput sgr0)";
}


main() {
  # Apple command line tools can be installed with `xcode-select --install`
  notice "You must agree to the XCode license."; # ------------------------------------------------------

  sudo xcodebuild -license accept;

  notice "Downloading and updating brew"; # -------------------------------------------------------------

  if ! type -t brew; then
    >&2 echo "Downloading and installing Homebrew";
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
  fi;

  brew update;

  notice "Opening taps"; # ------------------------------------------------------------------------------

  brew tap "homebrew/cask";
  brew tap "homebrew/cask-fonts";
  brew tap "homebrew/cask-versions";
  brew tap "homebrew/core";
  brew tap "homebrew/services";

  notice "Latest bash shell"; # -------------------------------------------------------------------------

  # Use Homebrew's version of bash as the login shell.
  brew install bash;
  if ! grep "$(brew --prefix bash)/bin/bash" "/etc/shells" > /dev/null; then
    # ref: http://stackoverflow.com/a/550808
    echo "$(brew --prefix bash)/bin/bash" | sudo tee -a "/etc/shells" > /dev/null;
    chsh -s "$(brew --prefix bash)/bin/bash";
  fi;

  notice "Java JDKs"; # ---------------------------------------------------------------------------------

  # The jce-unlimited-strength-policy package is no longer required as of JDK v1.8.0.161.
  # Use the Adoptium (formerly AdoptOpenJDK) builds of the JDK instead of the Oracle ones.
  brew install temurin; # Latest JDK from Eclipse/Adoptium
  brew install temurin11; # v11 LTS JDK from Eclipse/Adoptium
  brew install temurin8; # v1.8 LTS JDK from Eclipse/Adoptium
  # brew install corretto; # Amazon JDK

  if [[ ! -d "/usr/local/sbin" ]]; then
    >&2 echo "Your sudo password is required to create /usr/local/sbin";
    sudo mkdir -p "/usr/local/sbin";
    # "id" is the replacement for whoami (via "man whoami").
    sudo chown "$(id -un):$(id -gn)" "/usr/local/sbin";
    # shellcheck disable=SC2010
    ls -lah "/usr/local/" | grep --color=none -E 's?bin';
  fi;

  # Try to keep these lists alphabetical for easy visual search.

  notice "Installing primary packages"; # ---------------------------------------------------------------

  brew install adr-tools;
  brew install ant; # for ivycp
  brew install ammonite-repl;
  brew install asciidoc;
  # brew install asdf;
  brew install awscli;

  brew install bats-core; # Shell script testing framework.
  brew install berkeley-db; # Needed for installing perl 5.26+ via perlbrew; ref: https://stackoverflow.com/a/46660972/41321

  brew install colordiff;
  brew install cosign;
  brew install coreutils;
  brew install csshx;
  brew install ctop;
  brew install curl;

  brew install dependency-check;
  brew install diceware;
  brew install ditaa;
  brew install dive;
#  brew install docker;                        # CLI; use Docker Desktop instead.
#  brew install docker-credential-helper;      # for docker-credential-osxkeychain; supplied by Docker Desktop
#  brew install docker-credential-helper-ecr;  # for docker-credential-helper-ecr-login; supplied by Docker Desktop
  brew install dockutil;
  brew install dog;
  brew install duf;
  brew install dust;

  brew install enchant;

  brew install findutils;
  brew install fswatch;

  brew install gawk;
  brew install gcviewer;
  brew install geoipupdate;
  brew install gettext;
  brew install gist;
  brew install git;
  brew install git-cal;
  brew install git-delta;
  # brew install git-extras;
  brew install git-gui; # gitk, etc.
  brew install git-secrets;
  brew install gnu-gar; # For avoiding MacOS/BSD tar extended info that GNU doesn't handle. On the GNU side these cause
                        # warnings like: "tar: Ignoring unknown extended header keyword 'LIBARCHIVE.xattr.com.dropbox.attrs'"
  brew install gnu-units;
  brew install gnupg;
  brew install gnupg2;
  brew install go;
  brew install go-jira;
  brew install gping;
  brew install graphviz;
  brew install grc;
  brew install grep;
  brew install grpc;

  brew install hadolint;
  brew install hr;
  brew install htop;
  brew install httpie;
  brew install hub;
  brew install hugo;
  brew install hunspell;
  brew install ipcalc;

  brew install ivy; # for ivycp

  brew install jenv; # rbenv for Java
  brew install jfrog-cli-go;
  brew install jless;
  brew install jmeter;
  brew install jq; # requires Java to be installed first.

  brew install kubernetes-cli;

  brew install lastpass-cli;
  brew install less; # includes lesskey (MacOS doesn't for some weird reason)
  brew install lesspipe;

  brew install mas;
  brew install maven;
  brew install mercurial; # aka "hg".
  brew install micro; # console editor.
  brew install midnight-commander;
  brew install mill;
  # brew install minikube;
  brew install most;
  brew install multitail;
  brew install mysql; # && brew services start mysql;
  brew install mysql@5.7; # && brew services start mysql@5.7;

  brew install nano;
  brew install npm;

  brew install opa;
  brew install openapi-generator;
  brew install openssl@1.1;

  brew install p7zip;
  brew install packer;
  brew install pandoc;
  brew install pinentry-mac && brew linkapps pinentry-mac;
  # brew install proguard;
  brew install pstree;
  brew install python;
  brew install pwgen;

  brew install rbenv;
  brew install rbenv-default-gems;
  brew install reattach-to-user-namespace;
  brew install redis;
  brew install rfcdiff; # required for github.com/lvc/installer-4j
  brew install rlwrap;
  brew install ruby-build;

  brew install safe-rm;
  brew install sbt; # requires Java to be installed first.
  brew install scala;
  brew install scalariform;
  brew install scalastyle;
  brew install sendemail;
  brew install shellcheck;
  brew install sleepwatcher; # expects /usr/local/sbin to exist, otherwise "brew link sleepwatcher" will fail.
  # brew install source-highlight; # Dependency of asciidoc.
  brew install sonar-scanner;
  brew install sqlite;
  # brew install sshrc"; # https://github.com/Russell91/sshrc (now in .dotfiles, + local mods)
  brew install sshuttle; # SSH auto-VPN
  brew install starship;

  brew install terminal-notifier && brew linkapps terminal-notifier;
  brew install terraform;
  brew install tree;

  brew install unzip;

  brew install vault; # Hashicorp Vault

  brew install wdiff; # required for github.com/lvc/installer-4j
  brew install wget;
  # brew install wrk;

  brew install xmlstarlet;
  brew install xz;

  brew install yamllint;
  brew install yarn;
  brew install yq;

  brew install zip;

  brew install coursier/formulas/coursier;
  brew install discoteq/discoteq/flock;
  brew install github/gh/gh;
  brew install homeport/tap/dyff;
  brew install johanhaleby/kubetail/kubetail;
  brew install mike-engel/jwt-cli/jwt-cli;
  brew install mongodb/brew/mongodb-community; # Needed by zd-remote-auth
  brew install moul/moul/docker-diff;
  brew install snyk/tap/snyk; # https://snyk.io
  brew install versent/taps/saml2aws;
  brew install vmware-tanzu/carvel/vendir;
  brew install zendesk/devops/scooter;

  notice "Command line completions"; # ------------------------------------------------------------------

  brew install bash-completion@2; # for Bash v4.1+
  brew install bundler-completion;
  # brew install docker-completion; # Installed as part of docker.
  # brew install docker-compose-completion;
  # brew install docker-machine-completion;
  brew install gem-completion;
  brew install launchctl-completion;
  brew install open-completion;
  brew install pip-completion;
  brew install rails-completion;
  brew install rake-completion;
  brew install ruby-completion;
#  brew install vagrant-completion;
  brew install yarn-completion;
  brew install zsh-completions;

  notice "Fonts"; # -------------------------------------------------------------------------------------

  # Hack info: https://github.com/chrissimpkins/Hack
  brew install homebrew/cask-fonts/font-hack;
  brew install homebrew/cask-fonts/font-hack-nerd-font;
  brew install homebrew/cask-fonts/font-fira-code;
  brew install homebrew/cask-fonts/font-fira-code-nerd-font;
  brew install homebrew/cask-fonts/font-go;
  brew install homebrew/cask-fonts/font-go-mono-nerd-font;
  brew install homebrew/cask-fonts/font-inter; # https://rsms.me/inter/
  brew install homebrew/cask-fonts/font-source-code-pro;
  brew install homebrew/cask-fonts/font-sauce-code-pro-nerd-font;

  # # Alternate JVMs
  # brew install graalvm/tap/graalvm-ce-java11;
  # brew install graalvm/tap/graalvm-ce-lts-java11;

  notice "Other tool casks"; # --------------------------------------------------------------------------

  brew install 1password;
  brew install 1password-cli;

  brew install aerial; # Screensaver
  brew install araxis-merge; # Was broken, may need to download and install manually.
  brew install authy;

  brew install ccmenu;
  brew install charles;

  brew install datadog-agent;
  brew install diffmerge;
  brew install homebrew/cask/docker; # Docker Desktop UI (originally I needed --force to avoid issues with existing completions).
  brew install dropbox;

  brew install google-cloud-sdk;
  # brew install gpg-suite;

  brew install insomnia; # REST API tester.

  brew install jetbrains-toolbox; # Manage IntelliJ, etc.

  brew install key-codes;

  brew install lastpass;

  brew install mysqlworkbench;

  brew install osxfuse;

  brew install paintbrush;
  brew install pdfkey-pro;
  brew install postman;

  brew install sqlitestudio;
  brew install sublime-text;
  brew install sublime-merge;

#  brew install vagrant;
  brew install veracrypt;
#  brew install virtualbox;
  brew install vlc;

  brew install xbar;    # The reboot of bitbar.
  brew install xquartz; # Legacy X11 support.

  notice "Python packages"; # ---------------------------------------------------------------------------

  # Python packages (no need for sudo when using brewed python)
  # easy_install "pip"; # pip is preinstalled with python 2.7.9+ or 3.4+
  local pythonPath="$(brew --prefix python)";
  "${pythonPath}/bin/pip3" install Pygments;
  "${pythonPath}/bin/pip3" install json-spec;
  "${pythonPath}/bin/pip3" install mintotp;
  "${pythonPath}/bin/pip3" install truffleHog;
  "${pythonPath}/bin/pip3" install xml2rfc; # via https://xml2rfc.tools.ietf.org/
  # pip install yamllint; # using brew instead.

  # Mac App Store packages are installed using the mas cli; must be logged
  # into your iCloud account for this to work.
  #
  # The list can be updated using:
  #
  #   mas list | sed -E -e "s/^([0-9][0-9]*) (.*)/mas install \1; # \2/g" | sort -t '#' -b -k2,2df | pbcopy;
  #
  notice "Mac App Store packages"; # --------------------------------------------------------------------

  mas install 1028918091; # APG (2.2)
  mas install 961632517; # Be Focused Pro (2.0)
  mas install 1121192229; # Better (2020.2)
  mas install 417375580; # BetterSnapTool (1.9.3)
  mas install 411246225; # Caffeine (1.1.1)
  mas install 574607554; # com.hummersoftware.ImageExifEditor (5.1.1)
  mas install 1333277187; # Disconnect Premium (3.1.2)
  mas install 462058435; # Microsoft Excel (16.40)
  mas install 784801555; # Microsoft OneNote (16.40)
  mas install 985367838; # Microsoft Outlook (16.40)
  mas install 462062816; # Microsoft PowerPoint (16.40)
  mas install 462054704; # Microsoft Word (16.40)
  mas install 504284434; # Multi Monitor Wallpaper (2.97)
  mas install 409203825; # Numbers (10.1)
  mas install 823766827; # OneDrive (20.084.0426)
  mas install 409201541; # Pages (10.1)
  mas install 1303222628; # Paprika Recipe Manager 3 (3.4.5)
  mas install 984335872; # PDF Image Xtractor (1.3.3)
  mas install 545164971; # PDF Toolkit+ (2.3)
  mas install 520993579; # pwSafe (4.17)
  mas install 871368974; # QR Crafter (1.0)
  mas install 466385995; # SciTE (4.4.4)
  mas install 496437906; # Shush (1.2.1)
  mas install 803453959; # Slack (4.8.0)
  mas install 552792489; # StatusClock (1.2)
  mas install 435410196; # Stay (1.3)
  mas install 1191449274; # ToothFairy (2.6.2)
  mas install 533696630; # Webcam Settings (3.0)
  mas install 497799835; # Xcode (11.3.1)

  # For HTTPie (https://github.com/jkbrzt/httpie), SNI (Server Name Indication)
  # support needs updated stuff for Python versions < 2.7.9
  # sudo pip install --upgrade pyopenssl pyasn1 ndg-httpsclient;

  notice "Configuring jenv"; # --------------------------------------------------------------------------

  # The current version of the jenv formula (as at 2018-06-01) doesn't create
  # the ~/.jenv/versions folder, which is required when using "jenv add".
  mkdir -p "${HOME}/.jenv/versions";

  # If the ~/.jenv/versions folder is empty, add all of the current JDK installations into jenv.
  if [ -z "$(find "${HOME}/.jenv/versions" -mindepth 1 -maxdepth 1 -print -quit 2> /dev/null)" ]; then
    while IFS= read -r -d $'\n' jdk; do
      if [ -d "${jdk}/Contents/Home/bin" ]; then
        jenv add "${jdk}/Contents/Home";
      fi;
    done < <(find /Library/Java/JavaVirtualMachines -type d -maxdepth 1 -mindepth 1 -print);
  fi;

  # Default to Java 11 for SBT.
  if [ ! -r "${HOME}/.jenv/version" ]; then
    jenv global 11;
    jenv rehash;
  fi;
}

main "$@";

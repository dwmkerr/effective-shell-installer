#!/usr/bin/env bash

# Installer for the "Effective Shell" samples. If you are looking for the online
# book, just go to:
# 
#   https://effective-shell.com

# This script is used to allow a user to quickly download the samples for the
# 'effective shell' book on their local machine.
# 
# The goals of this script are:
# 
# - It *must* be secure - no need to run as 'sudo' and should not make any
#   sensitive changes to the machine.
# - It *must* be easy to use - a user can run `curl effective.sh | sh` to
#   install the samples.
# - It *must* be cross platform - users can use it on Linux, MacOS and WSL on
#   Windows and not require special software to be installed.
# - It *should* not interfere with any changes or work users have done with
#   with previous versions of the samples, so backups should be created.
# - It *should* be a good example of what an effective shell script looks like!
#
# Note that this script was inspired by NVM's installer:
#
#   https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh

#!/usr/bin/env bash

# Bail on errors.
set -e
set -o pipefail

# Uncomment the below if you want to enable tracing to debug the script.
# set -x

# We put everything in braces - this is to ensure we execute only when the whole
# script is downloaded.
{
    # Define the configuration for how the script will run.
    # We could allow this configuration to be overwritten later - this would
    # be useful for automated testing.
    #   es_force_install: if set, we will install the samples even if they
    #                     appear to be at the same version as the download.
    #   es_script_version: updating during the build to the version.txt
    es_interactive="1"
    es_source="https://effective-shell.com/downloads/effective-shell.tar.gz"
    es_dir="${HOME}/effective-shell"
    es_debug="${ES_DEBUG:-0}"
    es_force_install="${ES_FORCE_INSTALL:-0}"
    es_script_version="%%ES_SCRIPT_VERSION%%"
    es_existing_folder_action="${ES_EXISTING_FOLDER_ACTION}"
    
    # Print a debug level message.
    es_debug () {
      if [ "${es_debug}" = "1" ]; then
          command printf "effective-shell(debug): %s\\n" "$*" 2>/dev/null
      fi
    }

    # Print a message with a hint it's from the effective shell script.
    es_echo () {
      local green='\e[0;32m'
      local reset='\e[0m'
      command printf "${green}effective-shell${reset}: %s\\n" "$*" 2>/dev/null
    }

    # Define a cleanup function that we will call when the script exits or if
    # it is aborted.
    es_cleanup () {
        es_debug "cleaning up..."
        # Cleanup the temporary files/folders if they exist.
        if [ -e "${es_tmp_tar}" ]; then rm "${es_tmp_tar}"; fi
        if [ -d "${es_tmp_dir}" ]; then rm -rf "${es_tmp_dir}"; fi
    }

    # In debug mode, show the values of the variables.
    if [ "${es_debug}" = "1" ]; then
        es_debug "Script Parameters:"
        es_debug "  es_interactive: ${es_interactive}"
        es_debug "  es_source: ${es_source}"
        es_debug "  es_dir: ${es_dir}"
        es_debug "  es_debug: ${es_debug}"
        es_debug "  es_force_install: ${es_force_install}"
        es_debug "  es_script_version: ${es_script_version}"
    fi

    # Inform the user that we are going to download the samples.
    es_debug "effective-shell-installer v${es_script_version}:"
    es_echo "preparing to download the 'effective-shell.com' samples..."

    # Before we start creating temporary files and folders, set our traps.
    trap "es_cleanup" INT TERM EXIT

    # Create a temporary location to download the samples to.
    # Create a path in our temp dir to hold the tarball.
    es_tmp_dir=$(mktemp -d 2>/dev/null || mktemp -d -t 'effective-shell')
    es_tmp_tar="${es_tmp_dir}/effective-shell.tar.gz"
    es_debug "temporary directory is '${es_tmp_dir}'..."
    es_debug "temporary download tarball is '${es_tmp_tar}'..."

    # Download the samples. Don't show any output.
    curl --fail --compressed -q -s "${es_source}" -o "${es_tmp_tar}" >/dev/null 2>&1

    # Extract the samples.
    tar -xzf "${es_tmp_tar}" -C "${es_tmp_dir}"

    # Delete the downloaded tarball.
    rm "${es_tmp_tar}"

    # Let the user know what the version of the samples downloaded is.
    # We cut out the version field of the package json for this.
    version_downloaded=$(cat ${es_tmp_dir}/.package.json |\
        grep version | head -n 1 | cut -d'"' -f 4)
    
    es_echo "downloaded samples, version ${version_downloaded}"

    # Check to see if we can determine the installed version of the samples.
    version_installed=""
    if [ -s "${es_dir}/.version.txt" ]; then
        version_installed=$(cat "${es_dir}/.version.txt")
    fi
    es_debug "installed version is ${version_installed}"
    
    # If the downloaded version is the same as the installed version and we have
    # NOT set the 'force' option, we can finish now.
    if [ "${version_downloaded}" = "${version_installed}" ] && [ "${es_force_install}" != "1" ]
    then
        es_echo "the installed version is also ${version_installed}, skipping install"
        es_echo "if yout want to install anyway, run with 'ES_FORCE_INSTALL=1' option set"
        exit 0
    fi

    # Inform the user that we're going to try and install the samples.
    es_echo "preparing to install the 'effective-shell.com' samples..."

    # Does the samples folder already exist?
    if [ -e "${es_dir}" ]; then
        # It does, ask the user what they would like to do. The
        # es_existing_folder_action variable may have been set from the
        # environment, so we might not have to show the menu.
        choice="${es_existing_folder_action}"
        # Note we avoid Bash-isms in the if statement to maximize compatiblity
        # for the script.
        while [ "${choice}" != "d" ] && [ "${choice}" != "o" ] && [ "${choice}" != "q" ]; do
            es_echo "the '${es_dir}' folder already exists, would you like to:"
            es_echo "[d]elete - remove the existing folder"
            es_echo "[o]verwrite - extract over the existing folder"
            es_echo "[q]uit"

            # Remember 'read -p' doesn't work in zsh, so printf/read for
            # maximum compatiblity. We run 'read' in a subshell so that we can
            # cancel with Ctrl+C. Also note that if we curl the script into a
            # shell, the shell won't have a terminal and 'read' will immediately
            # abort. So when we read, read from the controlling terminals tty
            # device.
            printf "Your choice (d/o/q): "
            choice=$(read choice < /dev/tty; echo ${choice})
        done

        case ${choice} in
            d)
                es_echo "deleting '${es_dir}'..."
                rm -rf "${es_dir}"
                ;;
            o)
                es_echo "overwriting '${es_dir}'..."
                # Note: no action needed, we'll just replace the existing 
                # folder in the next step.
                ;;
            q)
                es_echo "quitting..."
                ;;
            *)
                es_echo "unexpected choice '${choice}'..."
                exit 1
                ;;
        esac
    else
        es_debug "the '${es_dir}' folder does not exist"
    fi

    # Move the samples to the target effective shell directory. Note that the
    # directory might already exist and have contents if the user has chosen to
    # overwrite the existing folder. So we copy, then delete the source.
    cp -rf "${es_tmp_dir}" "${es_dir}"
    rm -rf "${es_tmp_dir}"

    # Inform the user that the installation is complete and let them know where
    # they can read more.
    es_echo "installed samples version ${version_downloaded} to '${es_dir}'"
    es_echo "read 'effective shell' online at: effective-shell.com"

    # We have completed successfully.
    exit 0

# See the comment at the top - all funtionality is in braces so that we execute
# the script in its entirity when it is downloaded, rather than bit by bit.
}

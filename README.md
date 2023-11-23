# VSCode DevContainer with destop-lite feature

This repo demonstrates a problem on this version of Windows 11 & WSL:

```text
WSL version: 2.0.9.0
Kernel version: 5.15.133.1-1
WSLg version: 1.0.59
MSRDC version: 1.2.4677
Direct3D version: 1.611.1-81528511
DXCore version: 10.0.25131.1002-220531-1700.rs-onecore-base2-hyp
Windows version: 10.0.22631.2715
```

and this version of VSCode:

```text
Version: 1.84.2 (user setup)
Commit: 1a5daa3a0231a0fbba4f14db7ec463cf99d7768e
Date: 2023-11-09T10:51:52.184Z
Electron: 25.9.2
ElectronBuildId: 24603566
Chromium: 114.0.5735.289
Node.js: 18.15.0
V8: 11.4.183.29-electron.0
OS: Windows_NT x64 10.0.22631
```

The objective is to build a multi-platform (`amd64` and `arm64`) image that can be
use in the [`.devcontainer/devcontainer.json`](.devcontainer/devcontainer.json) file as the argument for the `image` property 
to speed up the VSCode DevContainer startup (about 10 seconds).

To reproduce:

1) Clone the repository in an Ubuntu WSL environment

    Using the same file system on the host (i.e. WSL Ubuntu environment) and the container simplifies 
    building the container since we do not have to worry about resolving differences about line endings and character encodings.

2) Edit the container to publish in a registry

    This problem was reproduced at JPL using an internal Artifactory registry.

    Change `artifactory-fn.jpl.nasa.gov:16001/gov/nasa/jpl/imce/autonomica/humble-ros-core-jammy:latest` to your registry in:
    - [`.devcontainer/devcontainer.json`](.devcontainer/devcontainer.json)
    - [`.github/build-devcontainer.sh`](.github/build-devcontainer.sh)

3) Start the docker engine (or equivalent), enabling integration w/ the WSL Ubuntu environment.

4) Make sure docker is authenticated to push images to the registry of your choice.

5) Build and publish the multi-platform DevContainer with the desired features

    ```shell
    .github/build-devcontainer.sh
    ```

6) Fetch the image

    ```shell
    docker pull artifactory-fn.jpl.nasa.gov:16001/gov/nasa/jpl/imce/autonomica/humble-ros-core-jammy:latest
    ```

6) In VSCode, invoke the command: "Dev Container: Rebuild Container without Cache"

The problems are explained in the context of the output of this command.

## Problem 1: Incomplete `/etc/hosts`

<details>

```text
[58 ms] Dev Containers 0.321.0 in VS Code 1.84.2 (1a5daa3a0231a0fbba4f14db7ec463cf99d7768e).
[57 ms] Start: Run: wsl -d Ubuntu-20.04 -e wslpath -u \\wsl.localhost\Ubuntu-20.04\opt\local\nfr\vscode-devc-ubuntu-desktop
[457 ms] Start: Resolving Remote
[460 ms] Start: Run: wsl -d Ubuntu-20.04 -e wslpath -u \\wsl.localhost\Ubuntu-20.04\opt\local\nfr\vscode-devc-ubuntu-desktop
[814 ms] Start: Run: wsl -d Ubuntu-20.04 -e /bin/sh -c cd '/opt/local/nfr/vscode-devc-ubuntu-desktop' && /bin/sh
[821 ms] Start: Run in host: id -un
[1048 ms] nfr
[1049 ms] 
[1049 ms] Start: Run in host:  (command -v getent >/dev/null 2>&1 && getent passwd 'nfr' || grep -E '^nfr|^[^:]*:[^:]*:nfr:' /etc/passwd || true)
[1050 ms] Start: Run in host: echo ~
[1051 ms] /home/nfr
[1051 ms] 
[1052 ms] Start: Run in host: test -x '/home/nfr/.vscode-remote-containers/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node'
[1053 ms] 
[1053 ms] 
[1053 ms] Exit code 1
[1054 ms] Start: Run in host: test -x '/home/nfr/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node'
[1054 ms] 
[1054 ms] 
[1055 ms] Start: Run in host: test -f '/home/nfr/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node_modules/node-pty/package.json'
[1055 ms] 
[1055 ms] 
[1055 ms] Start: Run in host: test -f '/home/nfr/.vscode-remote-containers/dist/vscode-remote-containers-server-0.321.0.js'
[1056 ms] 
[1056 ms] 
[1058 ms] userEnvProbe: loginInteractiveShell (default)
[1058 ms] userEnvProbe: not found in cache
[1059 ms] userEnvProbe shell: /bin/zsh
[1896 ms] userEnvProbe PATHs:
Probe:     '/home/nfr/.sdkman/candidates/java/current/bin:/home/nfr/.sdkman/candidates/gradle/current/bin:/opt/ros/noetic/bin:/snap/bin:/home/nfr/.krew/bin:/home/nfr/.elan/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/windows/system32:/mnt/c/windows:/mnt/c/windows/System32/Wbem:/mnt/c/windows/System32/WindowsPowerShell/v1.0/:/mnt/c/windows/System32/OpenSSH/:/mnt/c/Program Files (x86)/Enterprise Vault/EVClient/x64/:/mnt/c/Program Files (x86)/HID Global/ActivClient/:/mnt/c/Program Files/HID Global/ActivClient/:/mnt/c/Program Files (x86)/Pulse Secure/VC142.CRT/X64/:/mnt/c/Program Files (x86)/Pulse Secure/VC142.CRT/X86/:/mnt/c/Program Files (x86)/Common Files/Pulse Secure/TNC Client Plugin/:/mnt/c/Program Files (x86)/NVIDIA Corporation/PhysX/Common:/mnt/c/Program Files (x86)/GnuPG/bin:/mnt/c/Program Files/MATLAB/R2023a/runtime/win64:/mnt/c/Program Files/MATLAB/R2023a/bin:/mnt/c/Program Files/Git/cmd:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/Docker/host/bin:/mnt/c/Users/nfr/scoop/apps/nodejs/current/bin:/mnt/c/Users/nfr/scoop/apps/nodejs/current:/mnt/c/Users/nfr/go/bin:/mnt/c/Users/nfr/scoop/apps/python/current/Scripts:/mnt/c/Users/nfr/scoop/apps/python/current:/mnt/c/Users/nfr/scoop/apps/maven/current/bin:/mnt/c/Users/nfr/scoop/apps/nvm/current/nodejs/nodejs:/mnt/c/Users/nfr/scoop/apps/miniconda3/current/scripts:/mnt/c/Users/nfr/scoop/apps/miniconda3/current/Library/bin:/mnt/c/Program Files/MySQL/MySQL Shell 8.0/bin/:/mnt/c/Users/nfr/scoop/apps/pyenv/current/pyenv-win/bin:/mnt/c/Users/nfr/scoop/apps/pyenv/current/pyenv-win/shims:/mnt/c/Users/nfr/.elan/bin:/mnt/c/Users/nfr/scoop/apps/openjdk17/current/bin:/mnt/c/Users/nfr/scoop/apps/yarn/current/global/node_modules/.bin:/mnt/c/Users/nfr/scoop/apps/yarn/current/bin:/mnt/c/Users/nfr/scoop/shims:/mnt/c/Users/nfr/AppData/Local/Microsoft/WindowsApps:/mnt/c/Users/nfr/AppData/Local/Programs/Microsoft VS Code/bin:/mnt/c/Users/nfr/AppData/Local/JetBrains/Toolbox/scripts:/mnt/c/opt/local/ghcup/bin:/home/nfr/.antigen/bundles/robbyrussell/oh-my-zsh/lib:/home/nfr/.antigen/bundles/Tarrasch/zsh-autoenv:/home/nfr/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/scd:/home/nfr/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/kubectl:/home/nfr/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git:/home/nfr/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git-prompt:/home/nfr/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git-extras:/home/nfr/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git-auto-fetch:/home/nfr/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git-escape-magic:/home/nfr/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/gpg-agent:/home/nfr/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/microk8s:/home/nfr/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/minikube:/home/nfr/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/command-not-found:/home/nfr/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/urltools:/home/nfr/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/sbt:/home/nfr/.antigen/bundles/zsh-users/zsh-syntax-highlighting:/home/nfr/.local/bin'
Container: None
[1898 ms] Setting up container for folder or workspace: /opt/local/nfr/vscode-devc-ubuntu-desktop
[2011 ms] Start: Check Docker is running
[2012 ms] Start: Run in Host: docker version --format {{.Server.APIVersion}}
[2090 ms] Server API version: 1.43
[2090 ms] Start: Run in Host: docker volume ls -q
[2175 ms] Start: Run in Host: docker ps -q -a --filter label=vsch.local.folder=\\wsl.localhost\Ubuntu-20.04\opt\local\nfr\vscode-devc-ubuntu-desktop --filter label=vsch.quality=stable
[2282 ms] Start: Run in Host: docker ps -q -a --filter label=devcontainer.local_folder=\\wsl.localhost\Ubuntu-20.04\opt\local\nfr\vscode-devc-ubuntu-desktop --filter label=devcontainer.config_file=/opt/local/nfr/vscode-devc-ubuntu-desktop/.devcontainer/devcontainer.json
[2361 ms] Start: Run in Host: docker ps -q -a --filter label=devcontainer.local_folder=\\wsl.localhost\Ubuntu-20.04\opt\local\nfr\vscode-devc-ubuntu-desktop
[2443 ms] Start: Run in Host: /home/nfr/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node /home/nfr/.vscode-remote-containers/dist/dev-containers-cli-0.321.0/dist/spec-node/devContainersSpecCLI.js read-configuration --workspace-folder /opt/local/nfr/vscode-devc-ubuntu-desktop --id-label devcontainer.local_folder=\\wsl.localhost\Ubuntu-20.04\opt\local\nfr\vscode-devc-ubuntu-desktop --id-label devcontainer.config_file=/opt/local/nfr/vscode-devc-ubuntu-desktop/.devcontainer/devcontainer.json --log-level debug --log-format json --config /opt/local/nfr/vscode-devc-ubuntu-desktop/.devcontainer/devcontainer.json --mount-workspace-git-root
[2633 ms] @devcontainers/cli 0.52.1. Node.js v18.15.0. linux 5.15.133.1-microsoft-standard-WSL2 x64.
[2633 ms] Start: Run: docker ps -q -a --filter label=devcontainer.local_folder=\\wsl.localhost\Ubuntu-20.04\opt\local\nfr\vscode-devc-ubuntu-desktop --filter label=devcontainer.config_file=/opt/local/nfr/vscode-devc-ubuntu-desktop/.devcontainer/devcontainer.json
[2748 ms] Start: Run in Host: /home/nfr/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node /home/nfr/.vscode-remote-containers/dist/dev-containers-cli-0.321.0/dist/spec-node/devContainersSpecCLI.js up --container-session-data-folder /tmp/devcontainers-4673b515-96da-47be-b264-4c326be0d51b1700719337050 --workspace-folder /opt/local/nfr/vscode-devc-ubuntu-desktop --workspace-mount-consistency cached --id-label devcontainer.local_folder=\\wsl.localhost\Ubuntu-20.04\opt\local\nfr\vscode-devc-ubuntu-desktop --id-label devcontainer.config_file=/opt/local/nfr/vscode-devc-ubuntu-desktop/.devcontainer/devcontainer.json --log-level debug --log-format json --config /opt/local/nfr/vscode-devc-ubuntu-desktop/.devcontainer/devcontainer.json --default-user-env-probe loginInteractiveShell --build-no-cache --remove-existing-container --mount type=volume,source=vscode,target=/vscode,external=true --mount type=bind,source=/mnt/wslg/runtime-dir/wayland-0,target=/tmp/vscode-wayland-2333cac3-4215-4319-88e7-e60eaac0d432.sock --skip-post-create --update-remote-user-uid-default on --mount-workspace-git-root
[2954 ms] @devcontainers/cli 0.52.1. Node.js v18.15.0. linux 5.15.133.1-microsoft-standard-WSL2 x64.
[2954 ms] Start: Run: docker buildx version
[3091 ms] github.com/docker/buildx v0.11.2-desktop.5 f20ec1393426619870066baba9618cf999063886
[3091 ms] 
[3091 ms] Start: Resolving Remote
[3261 ms] Start: Run: docker ps -q -a --filter label=devcontainer.local_folder=\\wsl.localhost\Ubuntu-20.04\opt\local\nfr\vscode-devc-ubuntu-desktop --filter label=devcontainer.config_file=/opt/local/nfr/vscode-devc-ubuntu-desktop/.devcontainer/devcontainer.json
[3336 ms] Start: Run: docker inspect --type image artifactory-fn.jpl.nasa.gov:16001/gov/nasa/jpl/imce/autonomica/humble-ros-core-jammy:latest
[3596 ms] Start: Run: docker-credential-desktop.exe get
[4803 ms] local container features stored at: /home/nfr/.vscode-remote-containers/dist/dev-containers-cli-0.321.0/dist/node_modules/vscode-dev-containers/container-features
[4805 ms] Start: Run: tar --no-same-owner -x -f -
[4834 ms] Start: Run: docker build -f /tmp/devcontainercli-nfr/updateUID.Dockerfile-0.52.1 -t vsc-vscode-devc-ubuntu-desktop-19c9960131f02345864e7b29986c067150f19945a0aabb0df8e9851c2532c550-uid --build-arg BASE_IMAGE=artifactory-fn.jpl.nasa.gov:16001/gov/nasa/jpl/imce/autonomica/humble-ros-core-jammy:latest --build-arg REMOTE_USER=vscode --build-arg NEW_UID=1000 --build-arg NEW_GID=1000 --build-arg IMAGE_USER=vscode /tmp/devcontainercli-nfr/empty-folder
[+] Building 1.9s (6/6) FINISHED                                 docker:default
 => [internal] load build definition from updateUID.Dockerfile-0.52.1      0.0s
 => => transferring dockerfile: 1.36kB                                     0.0s
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 2B                                            0.0s
 => [internal] load metadata for artifactory-fn.jpl.nasa.gov:16001/gov/na  1.8s
 => [1/2] FROM artifactory-fn.jpl.nasa.gov:16001/gov/nasa/jpl/imce/autono  0.0s
 => CACHED [2/2] RUN eval $(sed -n "s/vscode:[^:]*:\([^:]*\):\([^:]*\):[^  0.0s
 => exporting to image                                                     0.0s
 => => exporting layers                                                    0.0s
 => => writing image sha256:d913c693b27a12c11e2686cb624b9e0d66d57070ff866  0.0s
 => => naming to docker.io/library/vsc-vscode-devc-ubuntu-desktop-19c9960  0.0s

What's Next?
  View a summary of image vulnerabilities and recommendations → docker scout quickview
[7467 ms] Start: Run: docker -v
[7538 ms] Start: Run: docker events --format {{json .}} --filter event=start
[7551 ms] Start: Starting container
[7551 ms] Start: Run: docker run --sig-proxy=false -a STDOUT -a STDERR --mount source=/opt/local/nfr/vscode-devc-ubuntu-desktop,target=/vscode-devc-ubuntu-desktop,type=bind --mount type=volume,src=vscode,dst=/vscode --mount type=bind,src=/mnt/wslg/runtime-dir/wayland-0,dst=/tmp/vscode-wayland-2333cac3-4215-4319-88e7-e60eaac0d432.sock -l devcontainer.local_folder=\\wsl.localhost\Ubuntu-20.04\opt\local\nfr\vscode-devc-ubuntu-desktop -l devcontainer.config_file=/opt/local/nfr/vscode-devc-ubuntu-desktop/.devcontainer/devcontainer.json -u vscode --shm-size=2g --privileged --network=host --init --entrypoint /bin/sh -l devcontainer.metadata=[{"id":"ghcr.io/devcontainers/features/desktop-lite:1","init":true,"entrypoint":"/usr/local/share/desktop-init.sh"},{"mounts":[],"containerUser":"vscode","remoteUser":"vscode","portsAttributes":{"6080":{"label":"Web VNC"}},"forwardPorts":[6080]}] vsc-vscode-devc-ubuntu-desktop-19c9960131f02345864e7b29986c067150f19945a0aabb0df8e9851c2532c550-uid -c echo Container started
Container started
[7854 ms] Start: Run: docker ps -q -a --filter label=devcontainer.local_folder=\\wsl.localhost\Ubuntu-20.04\opt\local\nfr\vscode-devc-ubuntu-desktop --filter label=devcontainer.config_file=/opt/local/nfr/vscode-devc-ubuntu-desktop/.devcontainer/devcontainer.json
sudo: unable to resolve host MT-313357: No address associated with hostname
sudo: unable to resolve host MT-313357: No address associated with hostname
sudo: unable to resolve host MT-313357: No address associated with hostname
sudo: unable to resolve host MT-313357: No address associated with hostname
sudo: unable to resolve host MT-313357: No address associated with hostname
sudo: unable to resolve host MT-313357: No address associated with hostname
[7969 ms] Start: Run: docker inspect --type container 10febf50fa2b
sudo: unable to resolve host MT-313357: No address associated with hostname
sudo: unable to resolve host MT-313357: No address associated with hostname
sudo: unable to resolve host MT-313357: No address associated with hostname
sudo: unable to resolve host MT-313357: No address associated with hostname
```

</details>

In the above, there are several output lines like this:

```
sudo: unable to resolve host MT-313357: No address associated with hostname
```

These are symptomatic of the incompleteness of the `/etc/hosts` file:

```text
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

To fix this, there is a script that appends an entry according to `/etc/hostname`.

In VSCode, open another terminal and invoke:

```shell
~/hostname-fix.sh
```

## Problem 2: Sticky customizations

<details>

```text
[8078 ms] Start: Inspecting container
[8078 ms] Start: Run: docker inspect --type container 10febf50fa2b1b73be537b03094b6c97122ecf5b81ebe372b7d2c45186ece286
[8216 ms] Start: Run in container: /bin/sh
[8232 ms] Start: Run in container: uname -m
[8385 ms] x86_64
[8385 ms] 
[8385 ms] Start: Run in container: (cat /etc/os-release || cat /usr/lib/os-release) 2>/dev/null
[8387 ms] PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
[8387 ms] 
[8387 ms] Start: Run in container:  (command -v getent >/dev/null 2>&1 && getent passwd 'vscode' || grep -E '^vscode|^[^:]*:[^:]*:vscode:' /etc/passwd || true)
[8390 ms] Start: Run in container: test -f '/var/devcontainer/.patchEtcEnvironmentMarker'
[8391 ms] 
[8391 ms] 
[8391 ms] Exit code 1
[8391 ms] Start: Run in container: /bin/sh
[8400 ms] Start: Run in container: test ! -f '/var/devcontainer/.patchEtcEnvironmentMarker' && set -o noclobber && mkdir -p '/var/devcontainer' && { > '/var/devcontainer/.patchEtcEnvironmentMarker' ; } 2> /dev/null
[8544 ms] 
[8544 ms] 
[8544 ms] Start: Run in container: cat >> /etc/environment <<'etcEnvrionmentEOF'
[8552 ms] 
[8552 ms] 
[8553 ms] Start: Run in container: test -f '/var/devcontainer/.patchEtcProfileMarker'
[8556 ms] 
[8556 ms] 
[8556 ms] Exit code 1
[8557 ms] Start: Run in container: test ! -f '/var/devcontainer/.patchEtcProfileMarker' && set -o noclobber && mkdir -p '/var/devcontainer' && { > '/var/devcontainer/.patchEtcProfileMarker' ; } 2> /dev/null
[8559 ms] 
[8559 ms] 
[8559 ms] Start: Run in container: sed -i -E 's/((^|\s)PATH=)([^\$]*)$/\1${PATH:-\3}/g' /etc/profile || true
[8561 ms] 
[8561 ms] 
[8585 ms] Start: Run in Host: docker inspect --type container 10febf50fa2b1b73be537b03094b6c97122ecf5b81ebe372b7d2c45186ece286
[8721 ms] Start: Run in Host: docker exec -i -u root 10febf50fa2b1b73be537b03094b6c97122ecf5b81ebe372b7d2c45186ece286 /bin/sh -c echo "New container started. Keep-alive process started." ; export VSCODE_REMOTE_CONTAINERS_SESSION=4673b515-96da-47be-b264-4c326be0d51b1700719337050 ; /bin/sh
[8733 ms] Start: Run in Host: /home/nfr/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node /home/nfr/.vscode-remote-containers/dist/dev-containers-cli-0.321.0/dist/spec-node/devContainersSpecCLI.js read-configuration --workspace-folder /opt/local/nfr/vscode-devc-ubuntu-desktop --id-label devcontainer.local_folder=\\wsl.localhost\Ubuntu-20.04\opt\local\nfr\vscode-devc-ubuntu-desktop --id-label devcontainer.config_file=/opt/local/nfr/vscode-devc-ubuntu-desktop/.devcontainer/devcontainer.json --container-id 10febf50fa2b1b73be537b03094b6c97122ecf5b81ebe372b7d2c45186ece286 --log-level debug --log-format json --config /opt/local/nfr/vscode-devc-ubuntu-desktop/.devcontainer/devcontainer.json --include-merged-configuration --mount-workspace-git-root
[8920 ms] New container started. Keep-alive process started.
[9037 ms] @devcontainers/cli 0.52.1. Node.js v18.15.0. linux 5.15.133.1-microsoft-standard-WSL2 x64.
[9037 ms] Start: Run: docker inspect --type container 10febf50fa2b1b73be537b03094b6c97122ecf5b81ebe372b7d2c45186ece286
[9195 ms] Start: Inspecting container
[9195 ms] Start: Run in Host: docker inspect --type container 10febf50fa2b1b73be537b03094b6c97122ecf5b81ebe372b7d2c45186ece286
[9344 ms] Start: Run in Host: docker exec -i -u vscode -e VSCODE_REMOTE_CONTAINERS_SESSION=4673b515-96da-47be-b264-4c326be0d51b1700719337050 10febf50fa2b1b73be537b03094b6c97122ecf5b81ebe372b7d2c45186ece286 /bin/sh
[9357 ms] Start: Run in container: uname -m
[9528 ms] x86_64
[9529 ms] 
[9529 ms] Start: Run in container: (cat /etc/os-release || cat /usr/lib/os-release) 2>/dev/null
[9532 ms] PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
[9532 ms] 
[9532 ms] Start: Run in container:  (command -v getent >/dev/null 2>&1 && getent passwd 'vscode' || grep -E '^vscode|^[^:]*:[^:]*:vscode:' /etc/passwd || true)
[9535 ms] Start: Run in container: command -v git >/dev/null 2>&1 && cd '/vscode-devc-ubuntu-desktop' && test -d .git && test "$(stat -c %u .)" != "$(id -u)"
[9536 ms] 
[9536 ms] 
[9536 ms] Exit code 127
[9537 ms] Start: Updating configuration state
[9548 ms] Start: Setup shutdown monitor
[9550 ms] Forking shutdown monitor: c:\Users\nfr\.vscode\extensions\ms-vscode-remote.remote-containers-0.321.0\dist\shutdown\shutdownMonitorProcess \\.\pipe\vscode-remote-containers-66a32a4e-cb18-478a-af19-b50c4b67e317-sock singleContainer Debug c:\Users\nfr\AppData\Roaming\Code\logs\20231122T204605\window4\exthost\ms-vscode-remote.remote-containers 1700719337837
[9583 ms] Start: Run in container: test -d /home/vscode/.vscode-server
[9590 ms] 
[9591 ms] 
[9591 ms] Exit code 1
[9591 ms] Start: Run in container: test -d /home/vscode/.vscode-remote
[9595 ms] 
[9596 ms] 
[9596 ms] Exit code 1
[9596 ms] Start: Run in container: test ! -f '/home/vscode/.vscode-server/data/Machine/.writeMachineSettingsMarker' && set -o noclobber && mkdir -p '/home/vscode/.vscode-server/data/Machine' && { > '/home/vscode/.vscode-server/data/Machine/.writeMachineSettingsMarker' ; } 2> /dev/null
[9603 ms] 
[9604 ms] 
[9605 ms] Start: Run in container: mkdir -p '/home/vscode/.vscode-server/data/Machine' && cat >'/home/vscode/.vscode-server/data/Machine/settings.json' <<'settingsJSON'
[9615 ms] 
[9617 ms] 
[9618 ms] Start: Run in container: test -d /home/vscode/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e
[9621 ms] 
[9621 ms] 
[9622 ms] Exit code 1
[9622 ms] Start: Run in container: test -d /vscode/vscode-server/bin/linux-x64/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e
[9624 ms] 
[9624 ms] 
[9624 ms] Start: Run in container: mkdir -p '/home/vscode/.vscode-server/bin' && ln -snf '/vscode/vscode-server/bin/linux-x64/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e' '/home/vscode/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e'
[9629 ms] 
[9629 ms] 
[9630 ms] Start: Run in Host: docker exec -i -u root 10febf50fa2b1b73be537b03094b6c97122ecf5b81ebe372b7d2c45186ece286 /bin/sh
[9630 ms] Start: Launching Dev Containers helper.
[9630 ms] ssh-agent: SSH_AUTH_SOCK in container (/tmp/vscode-ssh-auth-1ede7450-52d9-455c-867b-32ce9d2e3fa5.sock) forwarded to wsl host (/tmp/ssh-mODxUJVonUup/agent.292).
[9631 ms] Start: Run in container: test -e /tmp/.X11-unix/X0
[9634 ms] Start: Run in container: touch '/vscode/vscode-server/bin/linux-x64/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e'
[9635 ms] 
[9635 ms] 
[9635 ms] Exit code 1
[9635 ms] Start: Run in container: mkdir -p '/tmp/.X11-unix'
[9640 ms] 
[9641 ms] 
[9641 ms] X11 forwarding: DISPLAY in container (:0) forwarded to wsl host (:0).
[9641 ms] Start: Run in container: gpgconf --list-dir agent-socket
[9648 ms] /home/vscode/.gnupg/S.gpg-agent
[9649 ms] 
[9649 ms] Start: Run in container: gpgconf --list-dir homedir
[9654 ms] /home/vscode/.gnupg
[9655 ms] 
[9655 ms] Start: Run in container: ls '/home/vscode/.gnupg/private-keys-v1.d' 2>/dev/null
[9664 ms] 
[9664 ms] 
[9664 ms] Exit code 2
[9665 ms] Start: Run in Host: gpgconf --list-dir agent-extra-socket
[9669 ms] /home/nfr/.gnupg/S.gpg-agent.extra
[9669 ms] 
[9669 ms] Start: Run in container: mkdir -p -m 700 '/home/vscode/.gnupg'
[9669 ms] gpg-agent: Socket in container (/home/vscode/.gnupg/S.gpg-agent) forwarded to wsl host (/home/nfr/.gnupg/S.gpg-agent.extra).
[9681 ms] 
[9682 ms] 
[9682 ms] Start: Run in container: command -v docker >/dev/null 2>&1
[9683 ms] Start: Run in Host: gpgconf --list-dir homedir
[9694 ms] 
[9694 ms] 
[9694 ms] Exit code 127
[9695 ms] Start: Run in Host: docker exec -i -u vscode 10febf50fa2b1b73be537b03094b6c97122ecf5b81ebe372b7d2c45186ece286 /bin/sh
[9696 ms] userEnvProbe: loginInteractiveShell (default)
[9696 ms] Start: Run in container: test -f '/tmp/devcontainers-4673b515-96da-47be-b264-4c326be0d51b1700719337050/env-loginInteractiveShell.json'
[9714 ms] /home/nfr/.gnupg
[9715 ms] 
[9716 ms] Start: Run in container: echo ~
[9718 ms] 
[9718 ms] 
[9718 ms] Exit code 1
[9718 ms] Start: Run in container: gpgconf --list-dir homedir
[9719 ms] userEnvProbe: not found in cache
[9719 ms] userEnvProbe shell: /bin/sh
[9727 ms] /home/vscode/.gnupg
[9727 ms] 
[9732 ms] Start: Run in container: # Test for /home/vscode/.ssh/known_hosts and ssh
[9736 ms] ssh not found
[9736 ms] 
[9736 ms] Exit code 1
[9736 ms] Start: Run in container: # Test for /home/vscode/.gnupg/pubring.kbx and gpg
[9740 ms] 
[9740 ms] 
[9740 ms] Start: Run in container: # Copy /home/nfr/.gnupg/pubring.kbx to /home/vscode/.gnupg/pubring.kbx
[9744 ms] 
[9744 ms] 
[9771 ms] Start: Run in Host: gpg-connect-agent updatestartuptty /bye
[9900 ms] 
[9900 ms] 
[9900 ms] Start: Run in container: command -v git >/dev/null 2>&1 && git config --system --replace-all credential.helper '!f() { /home/vscode/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node /tmp/vscode-remote-containers-1ede7450-52d9-455c-867b-32ce9d2e3fa5.js git-credential-helper $*; }; f' || true
[9906 ms] 
[9906 ms] 
[9907 ms] Start: Run in container: for pid in `cd /proc && ls -d [0-9]*`; do { echo $pid ; readlink /proc/$pid/cwd || echo ; readlink /proc/$pid/ns/mnt || echo ; cat /proc/$pid/stat | tr "
[9944 ms] /home/vscode
[9945 ms] 
[9946 ms] Start: Run in container: cat <<'EOF-/tmp/vscode-remote-containers-1ede7450-52d9-455c-867b-32ce9d2e3fa5.js' >/tmp/vscode-remote-containers-1ede7450-52d9-455c-867b-32ce9d2e3fa5.js
[9950 ms] 
[9951 ms] 
[9951 ms] Start: Run in container: cat <<'EOF-/tmp/vscode-remote-containers-server-1ede7450-52d9-455c-867b-32ce9d2e3fa5.js' >/tmp/vscode-remote-containers-server-1ede7450-52d9-455c-867b-32ce9d2e3fa5.js_1700719347788
[9958 ms] 
[9959 ms] 
[10004 ms] Start: Run in container: cat '/home/vscode/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/product.json'
[10020 ms] Start: Run in container: cat '/home/vscode/.vscode-server/data/Machine/.connection-token-1a5daa3a0231a0fbba4f14db7ec463cf99d7768e' 2>/dev/null || (umask 377 && echo '5c268935-5ac4-41b0-b54c-0b630ab4ee5a' >'/home/vscode/.vscode-server/data/Machine/.connection-token-1a5daa3a0231a0fbba4f14db7ec463cf99d7768e-2b5737fb-a2bc-4caa-af04-4867ea65acb0' && mv -n '/home/vscode/.vscode-server/data/Machine/.connection-token-1a5daa3a0231a0fbba4f14db7ec463cf99d7768e-2b5737fb-a2bc-4caa-af04-4867ea65acb0' '/home/vscode/.vscode-server/data/Machine/.connection-token-1a5daa3a0231a0fbba4f14db7ec463cf99d7768e' && rm -f '/home/vscode/.vscode-server/data/Machine/.connection-token-1a5daa3a0231a0fbba4f14db7ec463cf99d7768e-2b5737fb-a2bc-4caa-af04-4867ea65acb0' && cat '/home/vscode/.vscode-server/data/Machine/.connection-token-1a5daa3a0231a0fbba4f14db7ec463cf99d7768e')
[10029 ms] 5c268935-5ac4-41b0-b54c-0b630ab4ee5a
[10029 ms] 
[10029 ms] Start: Starting VS Code Server
[10030 ms] Start: Preparing Extensions
[10030 ms] Start: Run in container: test ! -f '/home/vscode/.vscode-server/data/Machine/.installExtensionsMarker' && set -o noclobber && mkdir -p '/home/vscode/.vscode-server/data/Machine' && { > '/home/vscode/.vscode-server/data/Machine/.installExtensionsMarker' ; } 2> /dev/null
[10034 ms] 
[10034 ms] 
[10036 ms] Extensions cache, install extensions: None
[10037 ms] Start: Run in container: test -d /home/vscode/.vscode-server/extensionsCache && ls /home/vscode/.vscode-server/extensionsCache || true
[10038 ms] 
[10038 ms] 
```

</details>

```text
[10039 ms] Start: Run in container: test -d /vscode/vscode-server/extensionsCache && ls /vscode/vscode-server/extensionsCache || true
[10042 ms] batisteo.vscode-django-1.14.0
donjayamanne.python-environment-manager-1.2.4
donjayamanne.python-extension-pack-1.7.0
grapecity.gc-excelviewer-4.2.58
kevinrose.vsc-python-indent-1.18.0
ms-azuretools.vscode-docker-1.28.0
ms-iot.vscode-ros-0.9.2
ms-python.python-2023.20.0
ms-python.vscode-pylance-2023.11.10
ms-toolsai.jupyter-2023.10.1100000000-linux-x64
ms-toolsai.jupyter-keymap-1.1.2
ms-toolsai.jupyter-renderers-1.0.17
ms-toolsai.vscode-jupyter-cell-tags-0.1.8
ms-toolsai.vscode-jupyter-powertoys-0.0.8
ms-toolsai.vscode-jupyter-slideshow-0.1.5
ms-vscode-remote.remote-containers-0.321.0
ms-vscode-remote.remote-ssh-0.107.0
ms-vscode-remote.remote-ssh-edit-0.86.0
ms-vscode-remote.remote-wsl-0.81.8
ms-vscode-remote.vscode-remote-extensionpack-0.24.0
ms-vscode.cpptools-1.18.5-linux-x64
ms-vscode.remote-explorer-0.4.1
ms-vscode.remote-server-1.5.0
njpwerner.autodocstring-0.6.1
visualstudioexptteam.intellicode-api-usage-examples-0.2.8
visualstudioexptteam.vscodeintellicode-1.2.30
wholroyd.jinja-0.0.8
```

The above customizations come from *other* DevContainers I use where the `devcontainer.json` has:

```json
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "ms-python.vscode-pylance",
        "ms-toolsai.jupyter",
        "ms-toolsai.jupyter-keymap",
        "ms-toolsai.jupyter-renderers",
        "ms-toolsai.vscode-jupyter-powertoys",
        "ms-vscode-remote.remote-ssh-edit",
        "donjayamanne.python-extension-pack",
        "ms-vscode-remote.vscode-remote-extensionpack",
        "ms-iot.vscode-ros"
      ]
    }
  }
```

Since this repository's `devcontainer.json` has no customizations, it is unclear what the output above means.

## Problem4 3: Web VNC does not connect

<detail>

```text
[10042 ms] 
[10042 ms] Extensions cache, link in container: None
[10042 ms] Optimizing extensions for quality: stable
[10043 ms] Start: Run in Host: docker exec -i -u vscode -e SHELL=/bin/sh -e VSCODE_AGENT_FOLDER=/home/vscode/.vscode-server -w /home/vscode/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e 10febf50fa2b1b73be537b03094b6c97122ecf5b81ebe372b7d2c45186ece286 /home/vscode/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/bin/code-server --log debug --force-disable-user-env --server-data-dir /home/vscode/.vscode-server --use-host-proxy --telemetry-level all --accept-server-license-terms --host 127.0.0.1 --port 0 --connection-token-file /home/vscode/.vscode-server/data/Machine/.connection-token-1a5daa3a0231a0fbba4f14db7ec463cf99d7768e --extensions-download-dir /home/vscode/.vscode-server/extensionsCache --start-server --disable-websocket-compression
[10094 ms] userEnvProbe PATHs:
Probe:     '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
Container: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
[10094 ms] Start: Run in container: mkdir -p '/tmp/devcontainers-4673b515-96da-47be-b264-4c326be0d51b1700719337050' && cat > '/tmp/devcontainers-4673b515-96da-47be-b264-4c326be0d51b1700719337050/env-loginInteractiveShell.json' << 'envJSON'
[10111 ms] 
[10112 ms] 
[10113 ms] Start: Run in container: umask 077 && XRD="/tmp/user/$(id -u)" && mkdir -p $XRD && echo $XRD
[10126 ms] /tmp/user/1000
[10126 ms] 
[10127 ms] Start: Run in container: test -e /tmp/user/1000/vscode-wayland-2333cac3-4215-4319-88e7-e60eaac0d432.sock || ln -sf /tmp/vscode-wayland-2333cac3-4215-4319-88e7-e60eaac0d432.sock /tmp/user/1000/vscode-wayland-2333cac3-4215-4319-88e7-e60eaac0d432.sock
[10135 ms] 
[10135 ms] 
[10299 ms] *
* Visual Studio Code Server
*
* By using the software, you agree to
* the Visual Studio Code Server License Terms (https://aka.ms/vscode-server-license) and
* the Microsoft Privacy Statement (https://privacy.microsoft.com/en-US/privacystatement).
*
[10315 ms] Server bound to 127.0.0.1:40833 (IPv4)
Extension host agent listening on 40833

[10316 ms] Start: Run in container: echo 40833 >'/home/vscode/.vscode-server/data/Machine/.devport-1a5daa3a0231a0fbba4f14db7ec463cf99d7768e'
[10322 ms] 
[10323 ms] 
[10323 ms] Port forwarding for container port 40833 starts listening on local port.
[10325 ms] Port forwarding local port 40833 to container port 40833
[10353 ms] Port forwarding connection from 50093 > 40833 > 40833 in the container.
[10354 ms] Start: Run in Host: docker exec -i -u vscode -e VSCODE_REMOTE_CONTAINERS_SESSION=4673b515-96da-47be-b264-4c326be0d51b1700719337050 10febf50fa2b1b73be537b03094b6c97122ecf5b81ebe372b7d2c45186ece286 /home/vscode/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node -e 
[10373 ms] Start: Run in container: # Test for /home/vscode/.gitconfig and git
[10377 ms] git not found
[10378 ms] 
[10378 ms] Exit code 1
[10407 ms] Start: Run in container: # Cleaning up git config
[10414 ms] 
[10415 ms] /bin/sh: 73: git: not found
/bin/sh: 73: git: not found
/bin/sh: 73: git: not found
/bin/sh: 78: git: not found
[10415 ms] Start: Run in container: command -v git >/dev/null 2>&1 && git config --global --replace-all credential.helper '!f() { /home/vscode/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node /tmp/vscode-remote-containers-1ede7450-52d9-455c-867b-32ce9d2e3fa5.js git-credential-helper $*; }; f' || true
[10419 ms] 
[10420 ms] 
[10554 ms] [06:02:28] 




[10584 ms] [06:02:28] Extension host agent started.
[10650 ms] [06:02:28] No uninstalled extensions found.
[10650 ms] [06:02:28] Started initializing default profile extensions in extensions installation folder. file:///home/vscode/.vscode-server/extensions
[10654 ms] [06:02:28] ComputeTargetPlatform: linux-x64
[10658 ms] [06:02:28] Completed initializing default profile extensions in extensions installation folder. file:///home/vscode/.vscode-server/extensions
[10741 ms] Port forwarding 50093 > 40833 > 40833 stderr: Connection established
[10765 ms] Port forwarding connection from 50097 > 40833 > 40833 in the container.
[10765 ms] Start: Run in Host: docker exec -i -u vscode -e VSCODE_REMOTE_CONTAINERS_SESSION=4673b515-96da-47be-b264-4c326be0d51b1700719337050 10febf50fa2b1b73be537b03094b6c97122ecf5b81ebe372b7d2c45186ece286 /home/vscode/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node -e 
[10814 ms] [06:02:28] [127.0.0.1][72408080][ManagementConnection] New connection established.
[10850 ms] [06:02:28] Log level changed to info
[11094 ms] Port forwarding 50097 > 40833 > 40833 stderr: Connection established
[11452 ms] [06:02:29] [127.0.0.1][d5cd801b][ExtensionHostConnection] New connection established.
[11478 ms] [06:02:29] [127.0.0.1][d5cd801b][ExtensionHostConnection] <453> Launched Extension Host Process.
[14181 ms] Port forwarding connection from 50105 > 40833 > 40833 in the container.
[14182 ms] Start: Run in Host: docker exec -i -u vscode -e VSCODE_REMOTE_CONTAINERS_SESSION=4673b515-96da-47be-b264-4c326be0d51b1700719337050 10febf50fa2b1b73be537b03094b6c97122ecf5b81ebe372b7d2c45186ece286 /home/vscode/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node -e 
[14442 ms] Port forwarding 50105 > 40833 > 40833 stderr: Connection established
[19450 ms] Port forwarding 50105 > 40833 > 40833 stderr: Remote close
[19463 ms] Port forwarding 50105 > 40833 > 40833 terminated with code 0 and signal null.
```

</detail>

In a separate terminal, I checked the logs:

```text
cat /tmp/Xtigervnc.log
** Thu Nov 23 06:02:25 UTC 2023 **
[Thu Nov 23 06:02:25 UTC 2023] Process started.
hostname: No address associated with hostname
tigervncserver: Could not acquire fully qualified host name of this machine.
[Thu Nov 23 06:02:25 UTC 2023] Process exited!
...
[Thu Nov 23 06:04:01 UTC 2023] Process started.
/usr/bin/xauth:  file /home/vscode/.Xauthority does not exist

New Xtigervnc server 'fluxbox' on port 5901 for display :1.
Use xtigervncviewer -SecurityTypes VncAuth -passwd /usr/local/etc/vscode-dev-containers/vnc-passwd :1 to connect to the VNC server.
```

```text
cat /tmp/noVNC.log
[Thu Nov 23 06:04:02 UTC 2023] Process started.
Warning: could not find self.pem
Using local websockify at /usr/local/novnc/noVNC-1.2.0/utils/websockify/run
Starting webserver and WebSockets proxy on port 6080
WebSocket server settings:
  - Listen on :6080
  - Web server. Web root: /usr/local/novnc/noVNC-1.2.0
  - No SSL/TLS support (no cert file)
  - proxying from :6080 to localhost:5901


Navigate to this URL:

    http://MT-313357:6080/vnc.html?host=MT-313357&port=6080

Press Ctrl-C to exit

```

```text
cat /tmp/container-init.log
[Thu Nov 23 06:02:25 UTC 2023] ** SCRIPT START **
[Thu Nov 23 06:02:25 UTC 2023] Running "/etc/init.d/dbus start".
[Thu Nov 23 06:02:25 UTC 2023] Starting Xtigervnc.
[Thu Nov 23 06:04:02 UTC 2023] Xtigervnc started.
[Thu Nov 23 06:04:02 UTC 2023] noVNC started.
[Thu Nov 23 06:04:02 UTC 2023] Executing "".
[Thu Nov 23 06:04:02 UTC 2023] ** SCRIPT EXIT **
```

```text
cat /tmp/dbus-daemon-system.log 
sudo: unable to resolve host MT-313357: No address associated with hostname
 * Starting system message bus dbus
   ...done.
```

Opening a browser at http://localhost:6080/vnc.html fails to connect.



FROM ros:humble-ros-core-jammy

# Add vscode user with same UID and GID as your host system
# (copied from https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user#_creating-a-nonroot-user)
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME


# Added a shell entry to the desktop menu.
COPY .fluxbox/menu /home/vscode/.fluxbox/menu

# Starting bash will execute the profile, 
# which will 'cd' to the project's workspace mount.
COPY .bash_profile /home/vscode/.bash_profile

# Added a script to fix the missing hostname entry in /etc/hosts, if needed
COPY hostname-fix.sh /home/vscode/hostname-fix.sh

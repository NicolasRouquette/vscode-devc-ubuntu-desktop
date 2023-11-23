source /etc/profile
source ~/.bashrc

# With the VS Code Dev Container, there are 2 file systems:
# - one for /vscode
# - one for the project workspace
# To find the mount location of the project workspace, we exclude /vscode
# and we use Awk's $NF to select the last field of the line.
# On Mac systems using docker and the grpcfuse file system, the project's mount shows as /grpcfuse
cd $(df -x overlay | grep "^\(:\|/dev\|grpcfuse\)" | grep -v '/vscode' | awk '{print $NF}')

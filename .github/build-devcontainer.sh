#!/bin/bash -e

# Move to the root directory of your repository.
REPO_DIR=$(git rev-parse --show-toplevel)
cd "$REPO_DIR"

cd .github

DEVCONTAINER_IMAGE="artifactory-fn.jpl.nasa.gov:16001/gov/nasa/jpl/imce/autonomica/humble-ros-core-jammy:latest"

PLATFORMS="linux/amd64,linux/arm64"

export DOCKER_CLI_EXPERIMENTAL=enabled

# Create a build kit with support for the platforms we need.
BUILDER_NAME="multi"

# Check if the builder already exists
if ! docker buildx ls | grep -qw "$BUILDER_NAME"; then
    echo "Builder '$BUILDER_NAME' does not exist. Creating..."
    # Create a new builder
    docker buildx create \
        --name "$BUILDER_NAME" \
        --platform "$PLATFORMS"
    # Set it as the default builder
    docker buildx use "$BUILDER_NAME"
    # Bootstrap 
    docker buildx inspect --bootstrap "$BUILDER_NAME"
else
    echo "Builder '$BUILDER_NAME' already exists."
fi

(cd .devcontainer && \
    devcontainer build \
    --no-cache \
    --workspace-folder . \
    --config devcontainer.json \
    --image-name $DEVCONTAINER_IMAGE \
    --platform $PLATFORMS \
    --push true )

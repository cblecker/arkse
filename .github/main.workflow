workflow "Publish Image on Release" {
  on = "release"
  resolves = ["Annotate Release", "Publish to Docker Hub"]
}

action "Login to Docker Hub" {
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_PASSWORD", "DOCKER_USERNAME"]
}

action "Build Image" {
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "build"
}

action "Publish to Docker Hub" {
  needs = ["Build Image", "Login to Docker Hub"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "publish"
}

action "Get Digest" {
  needs = ["Publish to Docker Hub"]
  uses = "actions/docker/cli@master"
  runs = "sh"
  args = ["-c", "docker images --digests cblecker/arkse > \"${GITHUB_WORKSPACE}/.image-digest\""]
}

action "Annotate Release" {
  needs = ["Get Digest"]
  uses = "cblecker/action-annotate-release@master"
  env = {
    ANNOTATION_FILE = ".image-digest"
  }
  secrets = ["GITHUB_TOKEN"]
}

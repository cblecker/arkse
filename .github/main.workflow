workflow "Publish Image on Release" {
  on = "release"
  resolves = ["Publish to Docker Hub"]
}

action "Login to Docker Hub" {
  uses = "actions/docker/login"
  secrets = ["DOCKER_PASSWORD", "DOCKER_USERNAME"]
}

action "Build Image" {
  uses = "actions/action-builder/docker"
  runs = "make"
  args = "build"
}

action "Publish to Docker Hub" {
  needs = ["Build Image", "Login to Docker Hub"]
  uses = "actions/action-builder/docker"
  runs = "make"
  args = "publish"
}

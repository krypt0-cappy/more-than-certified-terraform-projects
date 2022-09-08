terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.21.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}


resource "random_string" "random" {
  count   = 2
  length  = 4
  special = false
  upper   = false
}


resource "docker_container" "nodered_container" {
  count = 2
  name  = join("-",["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}

output "IP-Address" {
  value = [for i in docker_container.nodered_container[*]: join(":", [i.ip_address],i.ports[*]["external"])]
  description = "The IP address and external port of your container"
}

output "Container-name" {
  value = [for i in docker_container.nodered_container[*]: i.name]
  description = "The name of your container"
}

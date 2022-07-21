packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
    virtualbox = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

source "virtualbox-iso" "team-kiss-app" {
  vm_name              = "Team_Kiss_Base"
  guest_os_type        = "Other_Linux"
  guest_additions_mode = "disable"
  cpus                 = "2"
  memory               = "4096"
  iso_url              = "https://dl-cdn.alpinelinux.org/alpine/v3.16/releases/x86_64/alpine-virt-3.16.1-x86_64.iso"
  iso_checksum         = "sha256:ce507d7f8a0da796339b86705a539d0d9eef5f19eebb1840185ce64be65e7e07"
  ssh_username         = "root"
  ssh_password         = "password"
  nic_type             = "virtio"
  shutdown_command     = "poweroff"
  boot_command = [
    # login as root
    "root<enter><wait>",
    # Acquire an IP address in order to be able to issue HTTP requests
    "ifconfig eth0 up && udhcpc -i eth0<enter><wait5>",
    "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/alpine-install-options.txt<enter><wait>",
    "setup-alpine -f alpine-install-options.txt<enter><wait5>",
    # Set root user password
    "password<enter><wait>",
    "password<enter><wait5>",
    # Skip additional user creation
    "<wait>no<enter><wait10>",
    # Yes to erase disk prompt, and wait for partitioning to complete
    "<wait>y<enter><wait60>",
    # Reboot so that the newly installed volume gets mounted
    "reboot<enter><wait20>",
    # Not sure why we need to stop ssh
    #    "rc-service sshd stop<enter>",
    # Login after reboot
    "root<enter><wait>",
    "password<enter><wait5>",
    # Allow root user to ssh in
    "echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config<enter>",
    # Reboot
    "reboot<enter>"
  ]
  http_directory = "packer-inputs"

  format = "ova"
}

build {
  name    = "team_kiss_base"
  sources = ["sources.virtualbox-iso.team-kiss-app"]
}

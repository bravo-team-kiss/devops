source "virtualbox-ovf" "team-kiss-devtools" {
  source_path = "./output-team-kiss-corepkg/Team_Kiss_CorePkg.ova"
  # TODO once corepkg is stabilized, add checksum value here
  checksum = "none"
  vm_name = "Team_Kiss_Devtools"
  communicator = "ssh"
  ssh_username = "root"
  ssh_password = "password"
  shutdown_command = "poweroff"
  guest_additions_mode = "disable"
  format = "ova"
  keep_registered = true
}

build {
  name = "team_kiss_devtools"
  sources = ["sources.virtualbox-ovf.team-kiss-devtools"]
  provisioner "shell" {
    inline = [
      "apk add --no-cache tmux vim emacs nano curl bash",
      "apk add --no-cache g++ gfortran make musl-dev linux-headers",
      "apk add --no-cache python3 nodejs"
    ]
  }
}
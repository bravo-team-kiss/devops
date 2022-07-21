
source "virtualbox-ovf" "team-kiss-corepkg" {
  source_path = "./output-team-kiss-base/Team_Kiss_Base.ova"
  # TODO once base is stabilized, add checksum value here
  checksum = "none"
  vm_name = "Team_Kiss_CorePkg"
  communicator = "ssh"
  ssh_username = "root"
  ssh_password = "password"
  shutdown_command = "poweroff"
  guest_additions_mode = "disable"
  format = "ova"
  keep_registered = true
}

build {
  name = "team_kiss_corepkg"
  sources = ["sources.virtualbox-ovf.team-kiss-corepkg"]
  provisioner "shell" {
    inline = [
      "sed -e 's/#\\(http.*\\/v[0-9\\.]\\+\\/community\\)/\\1/' -i /etc/apk/repositories",
      "apk add --no-cache virtualbox-guest-additions",
      "apk add --no-cache docker docker-compose",
      "apk add --no-cache parted mandoc",
      "rc-update add docker boot",
      "service docker start"
    ]
  }
}
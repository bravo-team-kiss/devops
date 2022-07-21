source "virtualbox-ovf" "team-kiss-services" {
  source_path = "./output-team-kiss-devtools/Team_Kiss_DevTools.ova"
  # TODO once devtools is stabilized, add checksum value here
  checksum = "none"
  vm_name = "Team_Kiss_Services"
  communicator = "ssh"
  ssh_username = "root"
  ssh_password = "password"
  shutdown_command = "poweroff"
  guest_additions_mode = "disable"
  vboxmanage = [
    ["createmedium", "disk", "--filename", "storage/data.vdi", "--size", "20000"],
    ["storageattach", "{{.Name}}", "--storagectl", "IDE Controller", "--type", "hdd", "--medium", "storage/data.vdi", "--port", "0", "--device", "1"]
  ]
  format = "ova"
  keep_registered = true
}

build {
  name = "team_kiss_services"
  sources = ["sources.virtualbox-ovf.team-kiss-services"]

  provisioner "shell" {
    inline = [ "mkdir /var/team-kiss" ]
  }

  provisioner "file" {
    destination = "/var/team-kiss"
    source      = "./services"
  }

  provisioner "shell" {
    inline = [
      "parted -s /dev/sdb -- mklabel msdos mkpart primary ext4 2048s -1s",
      "mkfs.ext4 /dev/sdb1",
      "mkdir /var/data",
      "echo '/dev/sdb1\t/var/data\text4\trw,relatime 0 2' >> /etc/fstab",
      "mount -a",
      "cd /var/team-kiss/services",
      "docker-compose up -d",
      "echo '127.0.0.1 registry' >> /etc/hosts",
      "echo '127.0.0.1 influx' >> /etc/hosts"
    ]
  }
}
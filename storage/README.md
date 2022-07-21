This directory contains disk images. These images need to be manually removed before the VirtualBox virtual machines that use them can be rebuilt.

It may also be necessary to manually remove the disks from VirtualBox:

```
VBoxManage closemedium {UUID|filename}
```

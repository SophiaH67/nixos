# This file deceived you
# You expected to find docker,
# but IT IS ME!
# containerDisk image
FROM scratch
ADD --chown=107:107 nixos.qcow2 /disk/

#!/bin/sh

grep_packages() {
  grep-dctrl "$@" "$debci_chroot_path"/var/lib/apt/lists/*_debian_dists_${debci_suite}_main_binary-`dpkg-architecture -qDEB_HOST_ARCH`_Packages
}


grep_sources() {
  grep-dctrl "$@" "$debci_chroot_path"/var/lib/apt/lists/*_debian_dists_${debci_suite}_main_source_Sources
}


list_binaries() {
  pkg="$1"
  grep_packages -n -s Package -F Source,Package -X "$pkg" | sort | uniq
}


check_version() {
  # check source version for (available for this architecture) by looking at
  # the first binary package built from that source package
  local pkg="$1"
  first_binary=$(list_binaries "$pkg" | head -n 1)
  grep_packages -n -s Version -F Package -X "$first_binary" | sort -V | tail -n 1
}


first_banner=
banner() {
  if [ "$first_banner" = "$pkg" ]; then
    echo
  fi
  first_banner="$pkg"
  echo "$@" | sed -e 's/./—/g'
  echo "$@"
  echo "$@" | sed -e 's/./—/g'
  echo
}

indent() {
  sed -e 's/^/    /'
}

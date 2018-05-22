provider "google" {
  version = "~> 1.10"
  project = "<PROJECT_NAME>"
  credentials = "${file("${var.credentials_file_path}")}"
  region      = "us-central1"
  zone       = "us-east1-c"
}

resource "google_compute_instance" "tagged" {
  name         = "tf-bridge"
  machine_type = "f1-micro"
  tags         = ["bridge-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1404-trusty-v20160602"
    }
  }

  network_interface {
    network = "<NETWORK_NAME>"

    access_config {
      # Ephemeral
    }
  }


metadata_startup_script = <<SCRIPT
#!/bin/bash

cat > /etc/apt/sources.list.d/tor.list << EOF
deb https://deb.torproject.org/torproject.org trusty main
deb-src https://deb.torproject.org/torproject.org trusty main
EOF

yes | apt-get update
yes | apt-get install gpg

gpg --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add

yes | apt-get update
yes | apt-get install tor deb.torproject.org-keyring

echo "stopping tor after installing it \n"
service tor stop

cat > /etc/tor/torrc << EOF
SocksPort 0
ORPort 9001
BridgeRelay 1
Exitpolicy reject *:*

RelayBandwidthRate 5 MBits
RelayBandwidthBurst 10 MBits
AccountingStart month 1 00:00
AccountingMax 100 GB

RunAsDaemon 1
EOF

ufw allow 9001
echo "starting tor bridge \n"
service tor start
SCRIPT
}

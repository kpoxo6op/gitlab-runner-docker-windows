resource "google_compute_instance" "windows_vm" {
  name         = "gitlab-runner-windows"
  machine_type = "e2-medium"
  zone         = "australia-southeast1"

  tags = ["windows-vm-rdp"]

  boot_disk {
    initialize_params {
      image = "windows-server-2019-dc-v20200908"
      size  = 50
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    windows-startup-script-ps1 = file("startup-script.ps1")
  }

  service_account {
    email  = "infra-admin@gitlab-agent-pwsh.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}


resource "google_compute_firewall" "allow_rdp" {
  name    = "allow-rdp"
  project = "gitlab-agent-pwsh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = [var.my_ip_address]
  target_tags   = ["windows-vm-rdp"]
}

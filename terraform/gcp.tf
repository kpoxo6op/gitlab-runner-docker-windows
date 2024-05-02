data "template_file" "sysprep_script" {
  template = file("${path.module}/install-docker-register-runner.ps1")

  vars = {
    runner_token = gitlab_user_runner.runner.token
  }
}

resource "google_compute_instance" "windows_vm" {
  project      = "gitlab-agent-pwsh"
  name         = "gitlab-runner-windows"
  machine_type = "e2-medium"
  zone         = "australia-southeast1-a"

  tags = ["windows-vm-rdp", "windows-vm-ssh"]

  boot_disk {
    initialize_params {
      # ssh works
      # image = "projects/windows-cloud/global/images/windows-server-2022-dc-v20240111"
      # check if script by google enables ssh for this versin
      image = "projects/windows-cloud/global/images/windows-server-2019-dc-v20231213"
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
    # sysprep-specialize-script-ps1 = data.template_file.sysprep_script.rendered
    windows-startup-script-ps1    = data.template_file.sysprep_script.rendered
    enable-windows-ssh            = "TRUE"
    sysprep-specialize-script-cmd = "googet -noconfirm=true install google-compute-engine-ssh"
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

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  project = "gitlab-agent-pwsh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.my_ip_address]
  target_tags   = ["windows-vm-ssh"]
}

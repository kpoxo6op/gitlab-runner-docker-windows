data "template_file" "startup_script" {
  template = file("${path.module}/startup.ps1")

  vars = {
    runner_token = gitlab_user_runner.runner.token
  }
}

resource "google_compute_instance" "windows_vm" {
  project      = var.project_name
  name         = "gitlab-runner-windows"
  machine_type = "e2-medium"
  zone         = "australia-southeast1-a"

  tags = ["windows-vm-ssh"]

  boot_disk {
    initialize_params {
      image = "projects/windows-cloud/global/images/windows-server-2022-dc-v20240111"
      size  = 50
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata = {
    windows-startup-script-ps1    = data.template_file.startup_script.rendered
    enable-windows-ssh            = "TRUE"
    sysprep-specialize-script-cmd = "googet -noconfirm=true install google-compute-engine-ssh"
  }

  service_account {
    email  = "terraform-admin@${var.project_name}.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  project = var.project_name
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.my_ip_address]
  target_tags   = ["windows-vm-ssh"]
}

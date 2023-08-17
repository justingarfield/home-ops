terraform {
  required_providers {
    hyperv = {
      source  = "taliesins/hyperv"
      version = ">= 1.0.3"
    }
  }
}

provider "hyperv" {
  host            = ""
  user            = "terraform"
  # password      = "" # Use HYPERV_PASSWORD when calling
  tls_server_name = ""
  insecure        = false
  https           = true
  cacert_path     = ""
  #cert_path       = ""
  #key_path        = ""
}

resource "hyperv_network_switch" "k8s_staging_controlplane" {
  name                                    = "K8sStaging-ControlPlane"
  notes                                   = "Kubernetes Staging Environment - Control Plane Node vSwitch"
  allow_management_os                     = false
  enable_embedded_teaming                 = false
  enable_iov                              = false
  enable_packet_direct                    = false
  minimum_bandwidth_mode                  = "None"
  switch_type                             = "External"
  net_adapter_names                       = ["Broadcom NetXtreme Gigabit Ethernet #2"]
  default_flow_minimum_bandwidth_absolute = 0
  default_flow_minimum_bandwidth_weight   = 0
  default_queue_vmmq_enabled              = false
  default_queue_vmmq_queue_pairs          = 16
  default_queue_vrss_enabled              = false
}

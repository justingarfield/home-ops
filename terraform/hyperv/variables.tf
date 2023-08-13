variable "controlPlaneVhdLocation" {
  type        = string
  description = "Path to store the Control Plane VHD files"
}

variable "workerVhdLocation" {
  type        = string
  description = "Path to store the Worker VHD files"
}

variable "talosLinuxISOImage" {
  type        = string
  description = "Path to the Talos Linux ISO image"
}

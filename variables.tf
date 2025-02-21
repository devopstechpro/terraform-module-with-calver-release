variable "bucket_name" {
  type        = string
  description = "Name of the bucket"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Default labels for the bucket"
}

variable "lifecycle_rule" {
  type = list(object({
    action_type   = string
    condition_age = number
  }))
  default     = null
  description = "Optional lifecycle rules for the bucket"
}

variable "iam_binding" {
  type = list(object({
    role_name    = string
    members_name = list(string)
  }))
  default     = []
  description = "IAM bindings for the bucket"
}

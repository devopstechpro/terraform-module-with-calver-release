resource "google_storage_bucket" "this" {
  name          = var.bucket_name
  storage_class = "MULTI_REGIONAL"
  location      = "US"
  labels        = var.labels
  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule != null ? [var.lifecycle_rule] : []
    content {
      action {
        type = lifecycle_rule.value.action_type
      }
      condition {
        age = lifecycle_rule.value.condition_age
      }
    }
  }
}

resource "google_storage_bucket_iam_binding" "this" {
  for_each = { for idx, iam_binding in var.iam_binding : idx => iam_binding }
  bucket   = google_storage_bucket.this.name
  role     = each.value.role_name
  members  = each.value.members_name
}

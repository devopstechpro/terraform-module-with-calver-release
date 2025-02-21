bucket_name = "devops-techpro-semantic-versioning"
iam_binding = [ {
  role_name = "roles/viewer"
  members_name = [ "serviceAccount:devopstechpro@devops-techpro.iam.gserviceaccount.com" ]
} ]
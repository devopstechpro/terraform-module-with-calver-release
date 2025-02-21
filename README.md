# Terraform google buckets module with calver versioning

This repository contains reusable Terraform modules designed for managing bucket resources on GCP. This project shows how you can configure calver versioning for such module.

## Step-by-setup semantic versioning on a repo:

1. Create `.github/workflows/pipeline.yml` file
   ```
   name: Release
   on:
     push:
       branches:
         - main
     workflow_dispatch:

   permissions:
     contents: write # for checkout

   jobs:
     release:
       name: Release
       runs-on: ubuntu-latest
       permissions:
         contents: write # to be able to publish a GitHub release
         issues: write # to be able to comment on released issues
         pull-requests: write # to be able to comment on released pull requests
         id-token: write # to enable use of OIDC for npm provenance
       steps:
         - name: Checkout
           uses: actions/checkout@v4
           with:
             fetch-depth: 1
             fetch-tags: true
             persist-credentials: false

         - name: CalVer
           id: calver
           uses: energostack/calver-action@v1

         - uses: thejeff77/action-push-tag@v1
           with:
             tag: ${{ steps.calver.outputs.next_version }}
             message: '"${{ steps.calver.outputs.next_version }}: PR #${{ github.event.pull_request.number }} - ${{ github.event.pull_request.title }}"'

         - name: Create Release
           uses: softprops/action-gh-release@v1
           with:
             tag_name: ${{ steps.calver.outputs.next_version }}
             generate_release_notes: true
             prerelease: ${{ github.event_name == 'workflow_dispatch' }}
   ```

## References

1. [calver-action on Github marketplace](https://github.com/marketplace/actions/next-calver)

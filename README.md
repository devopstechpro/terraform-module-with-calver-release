# Terraform google buckets module with calver versioning

This repository contains reusable Terraform modules designed for managing bucket resources on GCP. This project shows how you can configure calver versioning for such module.

## Step-by-setup semantic versioning on a repo:

The calver actions needs/depends on multiple github actions to create and push a version/release. Specifically push-tag and create-release actions from marketplace.

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

         - name: CalVer
           id: calver
           uses: energostack/calver-action@v1
           with:
             prerelease: ${{ github.event_name == 'workflow_dispatch' }}

         - uses: thejeff77/action-push-tag@v1.0.0
           with:
             tag: ${{ steps.calver.outputs.next_version }}
             message: '"${{ steps.calver.outputs.next_version }}: PR #${{ github.event.pull_request.number }} - ${{ github.event.pull_request.title }}"'
           env:
             GITHUB_TOKEN: ${{ secrets.GH_TOKEN }}

         - name: Create Release
           uses: softprops/action-gh-release@v1
           with:
             tag_name: ${{ steps.calver.outputs.next_version }}
             generate_release_notes: true
             prerelease: ${{ github.event_name == 'workflow_dispatch' }}
           env:
               GITHUB_TOKEN: ${{ secrets.GH_TOKEN }}
   ```
2. You will need a [Github Personal Access Token](https://github.com/settings/personal-access-tokens/new) and store it as environment variable via `Settings > CI/CD > Actions variables > Secret`

3. Make and pull request and merge to Main or Master branch this will automatically publish a semantic release version tag for the commit.

## References

1. [calver-action on Github marketplace](https://github.com/marketplace/actions/next-calver)
2. [push-tag action on Github marketplace](https://github.com/marketplace/actions/push-any-git-tag)
3. [create-release action on Github marketplace](https://github.com/marketplace/actions/gh-release)


## Approach 2

1. Create `.github/workflows/pipeline.yml` file
  ```
   name: Release
   on:
     push:
       branches:
         - main
     workflow_dispatch:

   concurrency:
     publish_version


   jobs:
     publish:
       runs-on: ubuntu-latest
       timeout-minutes: 30
       steps:
         - uses: actions/checkout@v3
         - uses: cho0o0/calver-release-action@2022.12.14.1
           with:
             generate_release_notes: true
             dry_run: false
             # Do not use GITHUB_TOKEN if you want to trigger other workflows
             timezone: 'utc'
             api_token: ${{secrets.GH_TOKEN}}
             release_title: '${version}'
  ```
2. You will need a [Github Personal Access Token](https://github.com/settings/personal-access-tokens/new) and store it as environment variable via `Settings > CI/CD > Actions variables > Secret`

3. Make and pull request and merge to Main or Master branch this will automatically publish a semantic release version tag for the commit.

Ref:

1. [calver-release-action Github marketplace](https://github.com/marketplace/actions/next-calver)

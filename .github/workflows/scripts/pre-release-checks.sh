#!/bin/bash

set -xue
# Target version must match major.minor.patch and optional -rcX suffix
# where X must be a number.
TARGET_VERSION=${SOURCE_TAG#*release-v}
if ! echo "${TARGET_VERSION}" | egrep '^[0-9]+\.[0-9]+\.[0-9]+(-rc[0-9]+)*$'; then
  echo "::error::Target version '${TARGET_VERSION}' is malformed, refusing to continue." >&2
  exit 1
fi
# Target branch is the release branch we're going to operate on
# Its name is 'release-<major>.<minor>'
TARGET_BRANCH="release-${TARGET_VERSION%\.[0-9]*}"
# The release tag is the source tag, minus the release- prefix
RELEASE_TAG="${SOURCE_TAG#*release-}"
# Whether this is a pre-release (indicated by -rc suffix)
PRE_RELEASE=false
if echo "${RELEASE_TAG}" | egrep -- '-rc[0-9]+$'; then
  PRE_RELEASE=true
fi
# We must not have a release trigger within the same release branch,
# because that means a release for this branch is already running.
if git tag -l | grep "release-v${TARGET_VERSION%\.[0-9]*}" | grep -v "release-v${TARGET_VERSION}"; then
  echo "::error::Another release for branch ${TARGET_BRANCH} is currently in progress."
  exit 1
fi
# Ensure that release do not yet exist
if git rev-parse ${RELEASE_TAG}; then
  echo "::error::Release tag ${RELEASE_TAG} already exists in repository. Refusing to continue."
  exit 1
fi
# Make the variables available in follow-up steps
echo "TARGET_VERSION=${TARGET_VERSION}" >> $GITHUB_ENV
echo "TARGET_BRANCH=${TARGET_BRANCH}" >> $GITHUB_ENV
echo "RELEASE_TAG=${RELEASE_TAG}" >> $GITHUB_ENV
echo "PRE_RELEASE=${PRE_RELEASE}" >> $GITHUB_ENV

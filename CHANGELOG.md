# Changelog

## Unreleased

## 0.5.0

### What's Changed
* Fixes broken links in README by @csjones in https://github.com/tuist/SwiftyTailwind/pull/9
* docs: add csjones as a contributor for content by @allcontributors in https://github.com/tuist/SwiftyTailwind/pull/10
* chore(deps): update dependency apple/swift-log to from: "1.5.3" by @renovate in https://github.com/tuist/SwiftyTailwind/pull/11
* chore(deps): update actions/checkout action to v4 by @renovate in https://github.com/tuist/SwiftyTailwind/pull/13
* chore(deps): update dependency swift-server/async-http-client to from: "1.19.0" by @renovate in https://github.com/tuist/SwiftyTailwind/pull/12
* chore(deps): update dependency apple/swift-tools-support-core to from: "0.6.1" by @renovate in https://github.com/tuist/SwiftyTailwind/pull/14
* aarch64 support by @jagreenwood in https://github.com/tuist/SwiftyTailwind/pull/16

### New Contributors
* @csjones made their first contribution in https://github.com/tuist/SwiftyTailwind/pull/9
* @allcontributors made their first contribution in https://github.com/tuist/SwiftyTailwind/pull/10
* @jagreenwood made their first contribution in https://github.com/tuist/SwiftyTailwind/pull/16

**Full Changelog**: https://github.com/tuist/SwiftyTailwind/compare/0.4.0...0.5.0

## 0.4.0

### Changed

- Don't start `tailwind` in a new process to ensure it gets killed when the Swift process (parent process) exits [Commit](https://github.com/tuist/SwiftyTailwind/commit/6b0a133d6aa861d0554a0868041ef3d12cc91eec) by [@pepicrft](https://github.com/pepicrft)
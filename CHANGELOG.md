# v2.0.1 - 2022-07-14

## Fixes
- Prevent premature errors - if any - if invalid options are passed (617cbf0).
- Exit on error instead of printing property descriptions (bb96c57).

## Miscellaneous
- Make usage section more readable in codebase (2c1f3fa).

# v2.0.0 - 2022-07-12

## Fixes
- Fixes GitHub's dependency/dependents graph (baa6d26).
- Fixes script's dependencies (f3a2620).

## Miscellaneous
- Made adding new properties easier by setting properties as CLI-options automatically (637f2b9).
- Added URLs for issue tracking and naive documentation (470a5c6).
- Made script [`shellcheck`-compliant](https://github.com/koalaman/shellcheck).
- Removed stale example script (c614101).
- Adds changelog.

## Updates
- Deprecates display properties as shell function-"methods", requiring CLI usage instead (637f2b9).
- Renames script as its PyPI package `xdisplayinfo` (43c5545).

# v1.0.2 - 2022-07-10

## Features
- Creates wrapper PyPI package: https://pypi.org/project/xdisplayinfo/ (2046552).
- Supports picking single properties by adding CLI options (7266b4b).
- Exposes display properties as methods named as their CLI options (52dafb8).

## Fixes
- Fixes small typos (9b6fe62).

## Updates
- Deprecates line-parseable (porcelain) output, showing script's usage instead (3108415).
- Renames main script as its PyPI package `xdisplayinfo` (43c5545).

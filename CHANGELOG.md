# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Fixed
- Fix wrong `gsub!` to `gsub` inside method call.

## [2.0.0] - 2024-06-27
### Added
- Random damage generator.
- Generator of Robe of Useful Items's items.
## Changed
- Fully refurbished DDB methods, creating:
  - Attacks generator;
  - Traits generator; and
  - Legendary Actions generator.

## [1.1.2] - 2022-05-12
### Changed
- Powershell and Bash scripts not to change folders.
### Fixed
- Linux path reference.
- Output to-hit without the preceding (and implied) `1d20`.

## [1.1.0] - 2022-05-12
### Added
- Windows `.bat` file.
- Linux `.sh` file.
- GitHub page.

## [1.0.0] - 2022-05-12
### Added
- `Gemfile` and dependencies.
- Main functionalities:
  - To-hit generation;
  - Damage generation;
  - Healing generation;
  - Recharge generation; and
  - General generation.

[Unreleased]: https://github.com/Nereare/DDB-Rollable/compare/v2.0.0..HEAD
[2.0.0]: https://github.com/Nereare/DDB-Rollable/compare/v1.1.2...v2.0.0
[1.1.2]: https://github.com/Nereare/DDB-Rollable/compare/v1.1.0...v1.1.2
[1.1.0]: https://github.com/Nereare/DDB-Rollable/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/Nereare/DDB-Rollable/releases/tag/v1.0.0

# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## 1.2.4
### Added
- better tests with GH actions

## 1.2.3
### Fixed
- Issue with cp-public-key pulling key with encoding PEM instead of SSH, causing bad copies.

## 1.2.2
### Added
- Added upload-public-key command
### Removed
- Github actions main workflow. The latest roll out broke my workflow due to them converting to more of a yaml style CI config.

## 1.2.1
### Fixed
- Fixed issue with aws temp creds not adding a line break to the .env

## 1.2.0
### Fixed
- Fixing issue with temp-creds replacing previous values
### Changed 
-Changed the name of the EXPIRATION to AWS_SESSION_EXPIRATION to be more specific.

## 1.0.5
### Fixed
- Fixing issue with temp-creds. Replacing hard coded `.env` file with variable.

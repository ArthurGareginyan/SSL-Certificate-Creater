
# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.0] - 2023-07-22

##### Added
- **Support for multiple package managers**: Updated the `checkNeededPackages` function to use the available package manager (`apt-get`, `dnf`, `yum`, or `zypper`) on the system. If no known package manager is found, the script will display a message and exit.
- **User-specified certificate validity**: Added functions `setValidityPeriod` and `checkValidityPeriod` to allow the user to specify the validity period of the certificate (in days). This value is used when generating the certificate.

## [1.3.0] - 2023-07-21

- **Removed `sudo` usage within script**: The script already requires root privileges to run, and there's a function to check whether the script is run as root. So, `sudo` is no longer used when installing packages.
- **Introduced variables for directory paths**: Directory paths like `/etc/nginx/ssl` and `/etc/apache2/ssl` are now represented by variables. This makes it easier to maintain and modify the script in the future.
- **Merged certificate generation functions**: The parts of the script that generate SSL certificates for Nginx and Apache were very similar and have been merged into a single function. This function takes arguments to reduce repetition and improve maintainability.
- **Removed hard-coded server types**: The server type (NginX or Apache) is now passed as an argument to the certificate generation function. This improves the modularity of the script.

## [1.2.0] - 2020-05-01

## [1.0.0] - 2015-05-25
- Initial version of the SSL Certificate Creator script.

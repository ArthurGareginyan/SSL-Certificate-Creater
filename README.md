# SSL Certificate Automation Script (BASH)

To quickly and easily create a self-signed SSL certificate for Apache and Nginx web servers I wrote a little script in BASH.

![Screenshot of the Script in Action](screenshot.png)

This repository contains a BASH script that automates the creation of self-signed SSL certificates for Apache and Nginx web servers. The goal is to simplify and streamline the process of SSL certificate generation, allowing for secure network information transfers with minimal effort.

SSL certificates are required to ensure the secure transfer of information in the network. Self-signed SSL certificates, in the realm of cryptography and computer security, are identity certificates that are signed by the same entity they certify. Essentially, if you create the SSL certificate for your own domain or IP address, it will be self-signed. These certificates are most suited for internal use such as on an intranet.


## Usage

1. Before running the script, ensure it has the required executable permissions. This only needs to be done once, prior to the first execution of the script:

```bash
chmod +x ssl_crt_creater.sh
```

2. Run the `ssl_crt_creater.sh` script:
```bash
./ssl_crt_creater.sh
```

After the SSL certificate is created, you can then bind it to your server.


## Dependencies and Instructions

This script requires the `dialog` and `openssl` packages. The `dialog` package is used for menu rendering, while `openssl` is used for certificate creation. If these packages are not already installed, the script will prompt you to do so.

The commands used for certificate and key creation are as follows:

For NginX:

```bash
openssl req -new -x509 -days 365 -nodes -out /etc/nginx/ssl/$__servername.crt -keyout /etc/nginx/ssl/$__servername.key
```

For Apache:

```bash
openssl req -new -x509 -days 365 -nodes -out /etc/apache2/ssl/$__servername.crt -keyout /etc/apache2/ssl/$__servername.key
```

Here is a brief description of the command arguments:

- `req` - Request to create a new certificate.
- `-new` - Creates a Certificate Signing Request (CSR).
- `-x509` - Creates a self-signed certificate instead of a CSR.
- `-days 365` - Sets the certificate validity period to 365 days (1 year).
- `-nodes` - Prevents the private key from being encrypted.
- `-out` - Specifies the location to store the certificate.
- `-keyout` - Specifies the location to store the private key.

Upon execution, the script will generate a new certificate and a private RSA key with a length of 2048 bits. These will be placed in the respective working directories for Apache (`/etc/apache2/ssl/`) and Nginx (`/etc/nginx/ssl/`) with file permissions set to `600` for security reasons.

The generated private key and certificate can be found at:

- For Apache: `/etc/apache2/ssl/*.crt` and `/etc/apache2/ssl/*.key`
- For NginX: `/etc/nginx/ssl/*.crt` and `/etc/nginx/ssl/*.key`


## Contributing

Welcome and thanks! I appreciate you taking the initiative to contribute to this project.

Contributing isn’t limited to just code. I encourage you to contribute in the way that best fits your abilities, by writing tutorials, making translation to your native language, giving a demo at your local meetup, helping other users with their support questions, or revising  the documentation for this project.

Please take a moment to read the guidelines in the [CONTRIBUTING.md](CONTRIBUTING.md). Following them helps to communicate that you respect the time of the other contributors to the project. In turn, they’ll do their best to reciprocate that respect when working with you, across timezones and around the world.


## Security Vulnerabilities

If you discover a security vulnerability within this script, kindly email me directly. All security vulnerabilities will be promptly addressed.

## License

This script is an open-source software licensed under the [MIT License](LICENSE.md) and is distributed free of charge.

Commercial licensing (for projects that cannot use an open-source license) is available upon request.


## Author

Arthur Garegnyan

- Email: arthurgareginyan@gmail.com
- GitHub: [https://github.com/ArthurGareginyan/](https://github.com/ArthurGareginyan/)
- Website: [http://www.arthurgareginyan.com](http://www.arthurgareginyan.com)
- Donate: [http://www.arthurgareginyan.com/donate.html](http://www.arthurgareginyan.com/donate.html)

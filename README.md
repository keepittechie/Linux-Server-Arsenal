# Linux Server Arsenal

Welcome to the Linux Server Arsenal Collection repository! This repository contains a variety of scripts designed to simplify the management and configuration of Linux servers (Ubuntu, CentOS/RHEL, and Arch). Each script addresses specific tasks, ranging from network configuration to system backups, providing automated solutions for common administrative activities.

## About

These scripts are created and maintained by [KeepItTechie](https://youtube.com/@KeepItTechie). They are designed to be user-friendly and are thoroughly documented to help both beginners and advanced users manage their Linux servers more efficiently.

## Repository Contents

### Main Script: LinservArsenal

The `linservarsenal.sh` script provides an interactive terminal menu for managing the various scripts in this repository. Instead of running each script manually, you can launch the main script, which will display a menu allowing you to select and run the desired configuration or management script.

### Configuration and Management

- **Static IP Configuration**: Easily configure a static IP address using Netplan.
- **Firewall Setup**: Configure UFW (Uncomplicated Firewall) with predefined rules.
- **User Management**: Scripts for adding, deleting, and managing users and groups.
- **System Monitoring**: Tools for setting up system monitoring and alerts.
- **Package Management**: Automate the installation and update of essential packages.
- **Service Management**: Start, stop, and manage system services with ease.
- **Log Management**: Organize and clean system logs to maintain optimal performance.

### Database and Media

- **Auto Database**: Install MySQL, MariaDB, or PostgreSQL based on user selection.
- **Auto Media**: Install and configure Plex or Jellyfin media server.

### Containers

- **Auto Container**: Install Docker, Docker Compose, Podman, and LXC/LXD based on user selection.

### DNS and DHCP

- **Auto DNS**: Set up a DNS caching server using `dnsmasq` or a full DNS server using `bind9`.
- **Auto DHCP**: Install and configure a DHCP server using `isc-dhcp-server`.

### Monitoring and Backup

- **Prometheus and Grafana**: Install and configure Prometheus and Grafana for system and service monitoring.
- **BorgGuard Backup Script**: Automate backups with BorgBackup for secure and efficient data management.

### Additional Applications

- **Auto Redis**: Install and configure Redis.
- **Auto Elasticsearch**: Install and configure Elasticsearch.
- **Auto RabbitMQ**: Install and configure RabbitMQ.
- **Nginx Reverse Proxy**: Install and configure Nginx as a reverse proxy.

## Getting Started

### Cloning the Repository

To get started, clone this repository to your local machine:

```bash
git clone https://github.com/keepittechie/Linux-Server-Arsenal
cd Linux-Server-Arsenal
```

### Running the Main Menu Script

The `linservarsenal.sh` script provides a menu for easy script selection and execution. Make the script executable and run it as follows:

```bash
chmod +x linservarsenal.sh
sudo ./linservarsenal.sh
```

Once you run the script, you'll be presented with an interactive menu that lets you select the script you want to execute.

### Running Individual Scripts

You can also run individual scripts manually. Make all the scripts executable first:

```bash
chmod +x assets/*.sh
```

Run a specific script with the following command:

```bash
sudo ./assets/script-name.sh
```

For example, to install Apache Kafka, you can run:

```bash
sudo ./assets/apache-kafka.sh
```

## Contributions

We welcome contributions from the community! If you have a script that you believe would be a valuable addition to this collection, please submit a pull request. Ensure that your script is well-documented and follows the existing structure and conventions.

## Support

If you encounter any issues or have questions about the scripts, feel free to open an issue in this repository. You can also reach out to [KeepItTechie](https://youtube.com/@KeepItTechie) through the YouTube channel or the blog [KeepItTechie Docs](https://docs.keepittechie.com/).

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Acknowledgements

Special thanks to the open-source community and all contributors who have helped in developing and improving these scripts.

---

Keep learning and happy server management!

[KeepItTechie YouTube Channel](https://youtube.com/@KeepItTechie) | [KeepItTechie Blog](https://docs.keepittechie.com/)

# Gandi - DNS Manager

The aims of this project:
* a basic script to manage Gandi DNS zones by cli
* better versioning of the Gandi DNS zones

This script is a basic wrapper of [Gandi cli python scripts](https://github.com/Gandi/gandi.cli)
to only manage DNS.


## Requirements
It's mandatory to have `virtualenv`.

On Ubuntu/Debian, you just need to launch:
```
$ sudo apt-get update && sudo apt-get install virtualenv
```

You also need to know your Gandi production API key!
Enable and retrieve it via: https://www.gandi.net/admin/api_key


## Setup
Before starting, you need to setup your environment.

But don't worry you only need to launch the following command:
```
$ ./dnsManager.sh setupAccount
```


## Use it!
See the help to list all available actions
```
$ ./dnsManager.sh help
```


## Notes
 * all zone files are stored in `./dns_zones/` (eg: `./dns_zones/mydomain.com.txt`)
 * before editing and updating a zone, be sure to have the latest version of the zone (eg: `./dnsManager.sh getLastDomainZone mydomain.com`). To avoid crushing uncommitted modifications
 * if you have any doubt about your DNS modification, read the [Zone_file](https://en.wikipedia.org/wiki/Zone_file) wiki page and open a PR :)


## License
This project is under MIT license

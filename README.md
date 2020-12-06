OpenConnect docker image client for Cisco's AnyConnect SSL VPN
==============================================

 OpenConnect docker image depends on the latest version of `OpenConnect`, `oath-toolkit` & `socat` on top of [Alpine Linux](http://www.alpinelinux.org/).

How to use
-----

1. Build the Docker image:

    ```bash
    docker-compose build --force
    ```

1. Add `.env` file to set up VPN connection params:

    ```bash
    VPN_URL=<VPN gateway URL>
    VPN_USER=<Username>
    VPN_PASSWORD=<Password>
    VPN_OPTIONS=--protocol=<Protocol> \
                --authgroup=<VPN Group> \
                --servercert=<VPN Server Certificate> \
    #When using multi-factor authentication with TOTP add additional options:
                --timestamp --token-mode=totp --token-secret=<TOTP secret>
    #To expose VPN service ports outside Docker container add the group of environment variables for each VPN service:
    HOST_PORT_1=<Host port for service 1>
    VPN_SERVICE_HOST_PORT_1=<VPN service 1 endpoint ip:port>
    #...
    # HOST_PORT_N=<Host port for service N>
    # VPN_SERVICE_HOST_PORT_N=<VPN service N endpoint ip:port>
    ```

    _Don't use quotes around the values!_

    See the [openconnect documentation](https://www.infradead.org/openconnect/manual.html) for available options.

    Either set the password in the `.env` file or leave the variable `VPN_PASSWORD` unset, so you get prompted when starting up the container.

    To expose more than one VPN service outside the Docker container your need add additional ports mapping sections and PORT_MAP_APP environment variables for each service in the `docker-compose.yml` file

1. Start the Docker containers:

    ```bash
    docker-compose up -d --env-file `.env` --abort-on-container-exit
    ```

Contribute
----

Pull requests are very welcome!

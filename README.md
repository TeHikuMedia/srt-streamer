# Axia Livewire AoiP to Icecast2

Stream an Axia Livewire AoiP source to icecast2.

## tl;dr

```bash
docker pull kmahelona/axia-to-icecast
docker run -d \
  --restart always \
  --network="host" \
  --name axia_to_icecast \
  --env-file template.env \
  kmahelona/axia-to-icecast

```
What's happening:
1. Pull the docker
2. Run the docker with environment variables defined in template.env (you have to update these). 
   Run as a daemon and tell docker to always restart it, essentially always running on reboots and failures.
3. Tested on Ubuntu 20.04. I could not get docker on Windows to access the Axia network even with `--network="host"` 


## Network Configuration
It's important to properly connect your linux machine to the Axia audio network. Here's a copy of 
our netplan for the ethernet device (eno2) connected to our Axia network.

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eno2:
      dhcp6: no
      # Static IP, so dhcp is turned off
      dhcp4: no
      # This is the static IP for your linux machine.
      # The /24 is the subnet
      addresses:
        - 10.2.160.52/24
      # You need to set routes, otherwise you might have a
      # situation where the linux machine tries to access
      # the internet through your axia network, which for us
      # doesn't work
      # via: this is the gateway
      # to: think of this as a catch all for your IP addresses
      # in this case, we want our machine to send all IPs 
      # in the range 10.2.160.0/24 to the gateway 10.2.160.99
      # metric: sets a priority
      routes:
        - to: 10.2.160.0/24
          via: 10.2.160.99
          metric: 200
        # Here we want all the possible IP addresses for the
        # axia multicast IPs.
        - to: 239.192.0.0/16
          via: 10.2.160.99
          metric: 200
        # To SEND multicast RTP packets to the Axia network, we have
        # to set the scope to link.
        - to: 239.192.0.0/16
          scope: link
```
For more info on the IP addresses that Livewire use, see [here](https://github.com/anthonyeden/Axia-Livewire-Stream-Address-Helper).


# Inspiration / Helpful Links

- https://github.com/kylophone/xplay
- https://github.com/kylophone/a-look-at-livewire
- https://mediarealm.com.au/articles/open-source-broadcast-software-github/
- https://support.telosalliance.com/article/ewmogdoltp-calculating-a-multicast-address-from-livewire-channel-number
- Tricks to getting the rtp settings right https://github.com/openbroadcaster/obplayer/blob/48bdb82a46281d81b6dea5c4a9100edeb3a738ed/obplayer/streamer/rtsp.py#L54
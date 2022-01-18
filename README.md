# Debian astro as a local container
This container script includes `base` and `astro` definitions. The base
container is for creating an SSH tunnel. The astro defition displays a
Window Maker desktop over VNC, routeable through the tunnel when run
properly via `docker-compose.yaml`

## Setup
1. Read the Dockerfiles and GitHub Actions scripts.
2. Fork this repo into your user namespace in GitHub. The workflow will
   build and register containers for you. The users in the container
   will be named after your GitHub user.
3. Generate an SSH keypair on your local machine
   - `cd ; ssh-keygen -t ecdsa -f ~/.ssh/astro`
4. Run the base container and copy the public part of the new key in
   - `docker compose run base /bin/bash -l`
   - paste the contents of `~/.ssh/astro.pub` into
     `~/.ssh/authorized_keys`
   - `chmod 644 ~/.ssh/authorized_keys`
5. Append a host definition like this to `~/.ssh/config` on your local 
   machine
   ```
   Host astro
     HostName localhost
     Port 2223
     LocalForward 5910 astro:5910
     User ${your_github_username}
     IdentityFile ~/.ssh/astro
   ```
6. Edit `docker-compose.yaml` to share only the mounts you want between
   your local filesystem and the astro/base containers. It is currently 
   sharing the following:
   ```
   - ~/src:/home/$USER/src
   - ~/.config/git:/home/$USER/.config/git
   - ~/.vimrc:/home/$USER/.vimrc
   ```
## Connecting
1. Run the astro container from your local machine
   - `docker compose up`
2. Bring up the SSH tunnel in another shell on your local machine
   - `ssh astro`
3. VNC connect to through the tunnel, with something like MacOS Screen
   Sharing
   - Finder -> Go -> Connect to Server -> `vnc://localhost:5910`
   - See 'Bugs' for a password string

## Bugs
- There is currently a bug in MacOS 11.2 that does not allow the VNC
(MacOS Screen Sharing) dialog to connect through with null passwords, so 
this script sets the VNC password to "fixthisbug". This is fine because 
the VNC interface is presented only to the container network and 
authorization actually happens at the SSH step.
- X is an old protocol... probably needs to be optimized

# Debian astro as a local container
This container script includes `base` and `astro` definitions. The base
container is for creating an SSH tunnel. The astro definition displays a
WindowMaker desktop over VNC, routeable through the tunnel when run
properly via `docker-compose.yaml`

## Setup
1. Read the Dockerfiles and GitHub Actions scripts.
2. Fork this repo into your user namespace in GitHub. The workflow will
   build and register containers for you. The users in the containers
   will be named after your GitHub user.
3. Generate an SSH keypair on your container runner
   - `ssh-keygen -t ecdsa -f ~/.ssh/astro`
4. Run the base container and copy the public part of the new key in
   - `docker compose run base /bin/bash -l`
   - paste the contents of `~/.ssh/astro.pub` on your container runner 
     into `~/.ssh/authorized_keys` in the container environment
   - `chmod 644 ~/.ssh/authorized_keys`
5. Append a host definition like this to `~/.ssh/config` on your
   container runner 
   ```
   Host astro
     HostName localhost
     Port 2223
     LocalForward 5910 astro:5910
     User ${your_github_username}
     IdentityFile ~/.ssh/astro
   ```
6. Edit `docker-compose.yaml` to make two changes:
   1. Change all references of `image:` to your GHCR user namespace:
      `image: ghcr.io/${your_github_user}/astrobox:base`
   2. Share only the mounts you want between your host filesystem and 
      the astro/base containers. It is currently sharing the following:
      ```
         - ~/src:/home/$USER/src
         - ~/.config/git:/home/$USER/.config/git
         - ~/.vimrc:/home/$USER/.vimrc
      ```
## Connecting
'Container runner' is most likely your local machine. 
1. Run the astro container from your container runner
   - `docker compose up`
2. Bring up the SSH tunnel in another shell on your container runner
   - `ssh astro`
3. VNC connect to through the tunnel, with something like MacOS Screen
   Sharing
   - Finder -> Go -> Connect to Server -> `vnc://localhost:5910`
   - See 'Bugs' for a password string
- 'Container runner' could possibly use the `base` container as bastion 
remote host instead...

## Bugs
- There is currently a bug in MacOS 11.2 that does not allow the VNC
(MacOS Screen Sharing) dialog to connect through with null passwords, so 
this script sets the VNC password to "fixthisbug". This is fine because 
the VNC interface is presented only to the container network and 
authorization actually happens at the SSH step.
- The display options need to be optimized
- Needs local git env config


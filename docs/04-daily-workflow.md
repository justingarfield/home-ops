# Daily Workflow

**NOTE: This is definitely a WIP, as I'm most likely going to move everything over to [distrobox](https://github.com/89luca89/distrobox) soon. (stay tuned!!)**

## Table of Contents

* [TBD](#)

Outside of making sure you have VS Code installed locally, this entire repository can be worked on using what I call the "Home Ops Toolchain". This is a multi-architecture (`amd64`/`arm64`) container image that comes pre-installed with all the same versions of tooling, folder mappings, etc. that I used to work on this stack daily.

The main factor behind working this way, is that I reached my breaking point trying to work across a Windows Desktop PC _(amd64)_, M2 MacBook Air _(arm64)_, and a Linux Laptop _(amd64)_...not to mention trying to keep all the tooling binary versions in-sync across them all. Now I can just simply run the same version of the container image across all of them, and simply map some volumes into the container to work exactly the same across them all.

For more information on the Home Ops Toolchain and its usage, please see: [`docker/toolchain/README.md`](docker/toolchain/README.md)

## Prepare a `.env` file

Over time, everyone's environments change...Things get modified, programs get added / removed / updated, things become out-of-date, etc.

A `.env` file is a way for you to inform all of the provided Task files with values that match your particular environment.

## Docker

### Toolchain

I work across a Windows, Linux, and Mac environments in my own home on a daily basis. After a while, it can get insanely frustrating trying to keep things like Shell Configurations, Tooling Binaries, etc. aligned and in-sync.

After having seen other containerized projects out in the wild building their own toolchains (Talos Linux takes theirs to the extreme if you want to see an awesome example), I decided, why the hell not for my own purposes?

Rather than install things like `kubectl` and `yq` on all of my devices using the myriad of package managers and permutations across OSes, I simply just install docker locally and run this container image. It provides me with the same setup across all of my environments, and I can even share it with other people if they want a similar experience!

The only thing I don't currently run inside this container is the Azure CLI. I use their official image for this, as it adds an additional 10-15 minutes to the build time of this container, and I didn't want to consume a build agent for that long for a single binary.

```shell
docker run -e TERM -e COLORTERM -e LC_ALL=C.UTF-8 -v ./:/home/tcuser/home-ops -it --rm justingarfield/home-ops-toolchain:dev
```

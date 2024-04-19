# Containerized Toolchain

## Overview

This is a docker image that contains all the required tools to work with this environment.

It also has a pre-configured zsh shell with auto-completion pre-wired for any of the commands that support it.

## Why does it exist?

I work across Windows, Linux, and macOS desktop environments within my house, depending on what I'm focused on.

It can become a pain very quickly when trying to have matching tooling versions, binaries, configurations, shell setups, etc. across even just two devices, let-alone three-or-more all with differing OSes.

By having this container image, I can do mutli-architecture builds and have the same environment to work in regardless of which device I'm on. This is quite refreshing.

## Quick Usage

In order for this container to be of any use, you'll need to run it interactively and also map two volumes.

```shell
docker run \
    -e TERM \
    -e COLORTERM \
    -e LC_ALL=C.UTF-8 \
    -it --rm \
    -v /home/jgarfield/src/justingarfield/home-ops:/home/tcuser/src/justingarfield/home-ops \
    -v /mnt/o/home-ops:/home/tcuser/.out-folder \
    -v /var/run/docker.sock:/var/run/docker.sock \
    ghcr.io/justingarfield/home-ops-toolchain:main
```

Inside of the container is a `/home/tcuser/src/justingarfield/home-ops` folder, which is the default/expected location of a volume representing the local home-ops repository you've already cloned.

**(Optional)** Another folder expected inside of the container is `/home/tcuser/.out-folder`, you'll want to map that to a local folder you wish to store ZSH History and output files in.

**(Optional)** Another folder you can mount is `/var/run/docker.sock`, you'll need this if you plan on using `docker`, `docker buildx`, etc. inside the container.

## A high-level look

This diagram shows a high-level view of how the container image(s) get created using Docker Buildx, Qemu, and GitHub Actions.

[![](https://mermaid.ink/img/pako:eNqVVE2L2zAQ_StG5zi0UHrIoZASaAsbWrKHQqs9yPLYFtaHq49u02X_e2ckx0kWwlIfxqN5bzRvBklPTLoW2IZ12j3KQfhY3R245fbeJS8h_ORM9MC53epJWajulE1_cCm7EDT9lVbJkKNTiOBlzFGvFidCiOh1Ouf1KhY7pKaSWuFiAE0bYKDRMMfG1IBozeyVvSb3CL7W8Bt0_fbNiJHgpoC_KLQLhRNFIACFeNE5b7IfveidnXc-_kLzNwzF1iJFV4fU96hSOcvZw9J6Vdcfqp2TI_hOaaChnFcZPMDkgorOHwkMqem9mIbqk4qfU8Nthd-ZkjO2kqrQVGcPZXx3fqTp59qUU-xMKGk92Lj15v27W5hpb2Jf4wCeBBK6iMxQKMGctpQgcYc9bsftx6R0W6BF3ZlMNYm8371OziKQvF6vb1DBtlftL3pKJ-R9MXQW7bWCApP3Es41M5y9C_jFLL4JOSJ2MY3M3QurOjwXKDuvq1OArsM8oVPz1NdV04vei3EWBewha7oqcZG4dPKfiecelzG_lpZHng1bMQPeCNXiU_BEKGe4n8HsDbqt8CNn3D5nJt2Z-6OVbBN9ghVLUysi7JTAaRq26YQOGIWWjv2-vC75kVmxSdgfzp04z_8A_iOAtw?type=png)](https://mermaid.live/edit#pako:eNqVVE2L2zAQ_StG5zi0UHrIoZASaAsbWrKHQqs9yPLYFtaHq49u02X_e2ckx0kWwlIfxqN5bzRvBklPTLoW2IZ12j3KQfhY3R245fbeJS8h_ORM9MC53epJWajulE1_cCm7EDT9lVbJkKNTiOBlzFGvFidCiOh1Ouf1KhY7pKaSWuFiAE0bYKDRMMfG1IBozeyVvSb3CL7W8Bt0_fbNiJHgpoC_KLQLhRNFIACFeNE5b7IfveidnXc-_kLzNwzF1iJFV4fU96hSOcvZw9J6Vdcfqp2TI_hOaaChnFcZPMDkgorOHwkMqem9mIbqk4qfU8Nthd-ZkjO2kqrQVGcPZXx3fqTp59qUU-xMKGk92Lj15v27W5hpb2Jf4wCeBBK6iMxQKMGctpQgcYc9bsftx6R0W6BF3ZlMNYm8371OziKQvF6vb1DBtlftL3pKJ-R9MXQW7bWCApP3Es41M5y9C_jFLL4JOSJ2MY3M3QurOjwXKDuvq1OArsM8oVPz1NdV04vei3EWBewha7oqcZG4dPKfiecelzG_lpZHng1bMQPeCNXiU_BEKGe4n8HsDbqt8CNn3D5nJt2Z-6OVbBN9ghVLUysi7JTAaRq26YQOGIWWjv2-vC75kVmxSdgfzp04z_8A_iOAtw)

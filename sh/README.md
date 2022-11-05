## Installation

1. Install `Termux:Boot` app, `boinc`, `jq`, `termux-api`, `coreutils`, plus some other stuffs

    a. Copy `boinc-start` to `~/.termux/boot`

    or

    b. Copy `boinc-start` to your desired `$PATH` and symlink under `~/.termux/boot`

## Optional

1. Copy `boinc-config` and `boinc-monitor` to `$PREFIX/bin` or your desired `$PATH`

1. EXPERIMENTAL: Copy `boinc-start-autoscale` to to your desired `$PATH` and symlink under `~/.termux/boot`

## How to use examples

If you have copy the scripts to `$PATH`, you can

    # you don't need to manually start BOINC if you added to ~/.termux/boot
    $ boinc-start &

    $ watch boinc-monitor

    $ boinc-config set cpu 30

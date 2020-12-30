## Installation

1. Install `Termux:Boot` app, `boinc`, `jq`, `termux-api`, `coreutils`, plus some other stuffs

1.
    a. Copy `start-boinc` to `~/.termux/boot`

    or

    b. Copy `start-boinc` to your desired `$PATH` and symlink under `~/.termux/boot`

## Optional

1. Copy `config-boinc` and `monitor-boinc` to `$PREFIX/bin` or your desired `$PATH`

1. EXPERIMENTAL: Copy `start-boinc-autoscale` to to your desired `$PATH` and symlink under `~/.termux/boot`

## How to use examples

If you have copy the scripts to `$PATH`, you can

    # you don't need to manually start BOINC if you added to ~/.termux/boot
    $ start-boinc &

    $ watch monitor-boinc
    
    $ config-boinc set cpu 30

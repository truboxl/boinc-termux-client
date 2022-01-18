# truboxl/boinc-termux-client

This document intends to provide information on how to use BOINC on Termux. Optional technical details may be offered in the "doc" folder.

## Disclaimer on this repo

The information provided here are from my own thoughts and my current level of understanding. It may not be accurate with a bit of my own of bias at the time of writing. I will try to update this doc to be as correct as possible.

## Installation

Android users can install BOINC client from [Termux repo](https://github.com/termux/termux-packages/tree/master/packages/boinc). Simply install Termux from:

[F-Droid](https://f-droid.org/en/packages/com.termux/)

and install `boinc` using the command:

    $ pkg install boinc

Please make sure you know where you want to store the BOINC data as running a simple `boinc` can cause your home directory to be populated with unwanted files. Use `--dir` to point to a preferred location as BOINC data directory, example:

    $ boinc --dir ~/boincappdata

If you are a long time BOINC user, you can expect to do pretty much everything you do with BOINC on Desktop.

[`boinctui`](https://github.com/termux/termux-packages/tree/master/packages/boinctui) is also available if you want to use that.

## Build from source

This repo also contains a build script so that you can build BOINC on device in Termux environement. Feel free to modify. Standard build tools are needed.

Remember to add patches from <https://github.com/termux/termux-packages/tree/master/packages/boinc> to build BOINC properly.

Optionally, you can use patches included in this repo.

## Platform name correction

Originally Termux version of the client will have different platform name `$ARCH-unknown-linux-android` which may not be recognised by the project server. This has since been solved to use BOINC approved platform string. If for whatever reason the  issue is not solved, this can be fixed by adding `<alt_platform>` to `cc_config.xml` in the data directory. Example on an aarch64 Android device:

```
<cc_config>
<options>
<alt_platform>aarch64-android-linux-gnu</alt_platform>
</options>
</cc_config>
```

For other platforms, please refer: https://boinc.berkeley.edu/trac/wiki/BoincPlatforms

On how to use `cc_config.xml`, please refer: https://boinc.berkeley.edu/wiki/Client_configuration

## 32bit Android platform support

64bit Termux version of BOINC client will request from project server to download and run 32bit project tasks by default. Subject to project server availability. To disable requesting 32bit tasks, add this line to your `cc_config.xml`. Example on an aarch64 Android device:

```
<cc_config>
<options>
<no_alt_platform>1</no_alt_platform>
</options>
</cc_config>
```

Termux version of BOINC client will automatically `unset LD_PRELOAD` before running the 32bit tatsk. See [termux/termux-app#567](https://github.com/termux/termux-app/issues/567).

## Auto start BOINC at device boot

This requires Termux:Boot app. You need to install the correct version depending on the installed Termux app due to [different key signing](https://wiki.termux.com/wiki/Termux:Boot). You can install Termux:Boot from:

[FDroid](https://f-droid.org/en/packages/com.termux.boot/)

After that, add script to `~/.termux/boot` directory (you need to create one), eg: a script name `start-boinc` with the contents below:

```
#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
boinc --daemon --dir ~/boincappdata
```

TODO seems like there's `Termux-services` that maybe worth investigating and upstream the effort

## Device name change

Termux version of BOINC client will detect your device model name and assign a random ID so that you can better recognise your device when checking the project stats. The name will be in the form of:

    Manufacturer Model RandomID

You can still customise the name by simply change the device name using `cc_config.xml`.

```
<cc_config>
<options>
<device_name>your-device-name-here</device_name>
</options>
</cc_config>
```

## Remote monitoring and control

Passing `--allow_remote_gui_rpc` to BOINC allows the client to be connected to GUI Managers from Desktop. Find the IP address of your Android device and the correct port (default is 31416) and you can manage it remotely. If you can't connect, check `cc_config.xml` whether there's `<allow_remote_gui_rpc>` set to 0. Remove it and set to 1 if so.

Above allows all IP addresses to connect your client on your Android device which is unsafe! Try use `remote_hosts.cfg` to whitelist certain range of IP addresses.

See <https://boinc.berkeley.edu/wiki/Controlling_BOINC_remotely>

Example in `cc_config.xml` for all IP addresses access (unsafe):

```
<cc_config>
<options>
<allow_remote_gui_rpc>1</allow_remote_gui_rpc>
</options>
</cc_config>
```

## Suspend computing according to device temperature

An example script that allow Termux BOINC mimic BOINC app suspend computing when device is too hot is provided in the repo.

## Connect to project server

Once you are done with the above and started BOINC client, you can start running tasks by connecting to project server. This needs to be done one time only. See <https://boinc.berkeley.edu/wiki/Boinccmd_tool> on how to connect.

Example, replace "terms" with your own:

```
cd ~/boincappdata # your data directory

boinccmd --host localhost --passwd $(paste gui_rpc_auth.cfg) --lookup_account "project_URL" "username" "password"

boinccmd --host localhost --passwd $(paste gui_rpc_auth.cfg) --project_attach "project_URL" "account_key"
```

## Flexible controls

You can create scripts that interface with `boinccmd`, `cc_config.xml`, and `global_prefs_override.xml` to design various type of workloads in contrast to the limited BOINC app. More TODO needed.

## OpenCL platform support

Please read [this](doc/BOINC-OpenCL.md).

## GNU/Linux platform support (EXPERIMENTAL)

Please read [this](doc/BOINC-Termux-GNU.md).

## Comparison between BOINC app and Termux BOINC

Please read [this](doc/BOINC-Termux-comparison.md).

## Report issues

If you have read this far and plan to do this, you are really on your own. I do not think the BOINC guys endorse this nor the Termux guys able to solve whatever problems nor the project guys want to support such frankenstein platform. You can improve your findings here though. Make an issue or pull request.

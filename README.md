# boinc-termux-client

### Repo created by [truboxl](https://github.com/truboxl)

This document intends to provide information on how to use BOINC on Termux. Optional technical details may be offered in the "doc" folder.

## Disclaimer on this repo

The information provided here are from my own thoughts and my current level of understanding. It may not be accurate with a bit of my own of bias at the time of writing. I will try to update this doc to be as correct as possible.

## IMPORTANT: BOINC on Google Play situation

Please read [this](doc/BOINC-Google-Play.md).

## Installation

In addition of [the official BOINC for Android app](https://play.google.com/store/apps/details?id=edu.berkeley.boinc&hl=en), Android users can install BOINC client from [Termux repo](https://github.com/termux/termux-packages/tree/master/packages/boinc). Simply install Termux from:

[Google Play](https://play.google.com/store/apps/details?id=com.termux&hl=en)

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

<b>Update: This has been fixed since version 7.16.11! The client will automatically download the correct binaries based on your device architecture.</b>

Because of the way BOINC is built, Termux version of the client will have different platform name `$ARCH-unknown-linux-android` which may not be recognised by the project server. This can be solved by adding `<alt_platform>` to `cc_config.xml` in the data directory. Example on an aarch64 Android device:

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

<b>Update: This has been fixed since version 7.16.11! The client will automatically unset the variable before running 32bit executables if your device is 64bit.</b>

Certain projects may not provide 64bit version of their project binaries. They instead chose to provide 32bit version of the binaries. To request downloading 32bit version, add the appropriate `<alt_platform>` in `cc_config.xml`. Example on an aarch64 Android device:

```
<cc_config>
<options>
<alt_platform>arm-android-linux-gnu</alt_platform>
</options>
</cc_config>
```

Above is only adding the request to project server. To be able to execute in Termux, you need to `unset LD_PRELOAD` before running the BOINC client. See [termux/termux-app#567](https://github.com/termux/termux-app/issues/567). You can also launch the client with support of running 32bit binaries using:

    $ LD_PRELOAD='' boinc

## Auto start BOINC at device boot

This requires Termux:Boot app. You need to install the correct version depending on the installed Termux app due to [different key signing](https://wiki.termux.com/wiki/Termux:Boot). You can install Termux:Boot from:

[Google Play](https://play.google.com/store/apps/details?id=com.termux.boot&hl=en)

[FDroid](https://f-droid.org/en/packages/com.termux.boot/)

After that, add script to `~/.termux/boot` directory (you need to create one), eg: a script name `start-boinc` with the contents below:

```
#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
boinc --daemon --dir ~/boincappdata
```

TODO seems like there's `Termux-services` that maybe worth investigating and upstream the effort

## Device name change

<b>Update: This feature has been added since version 7.16.11! You only need to edit `cc_config.xml` to take effect (see below). No more building from source.</b>

[BOINC/boinc#3620](https://github.com/BOINC/boinc/pull/3620) introduced device name change feature so that users can change the default name `localhost`. This does mean you need to build BOINC from master branch until the next version release. See [truboxl/boinc-termux-client#1](https://github.com/truboxl/boinc-termux-client/issues/1) for reference.

After that you can change the device name using `cc_config.xml`. Simply add:

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
## Comparison between BOINC app and Termux BOINC

### From source code to binary

The Termux version of BOINC client is built more closer to GNU/Linux BOINC client than the Android BOINC app. This is controlled by the exclusion `-DANDROID` during building. Therefore, you are expected to be more familiar with using command line here. This does not mean you have to entirely rely on command line. Unlike the Android app which use Unix socket, Termux BOINC client allows remote connection from BOINC manager through the use of a network port (like on the Desktop GNU/Linux version) so you can create custom GUI (even mimic the Android app to a certain extent) to control the BOINC client.

When installing BOINC on Termux, it installs `boinc_client` (the client), `boinc` (a symbolic link to `boinc_client`), `boinccmd` (the command line interface to the client) and some other files. This is in contrast to Android app, which only has `boinc` client and GUI portion.

Removing `-DANDROID` also disables a lot of broken Android workarounds on newer Android versions that are unnecessary.

### Power Management

The `boinccmd` is pretty much your only way to control the client if you do not want to use `boinctui` or another GUI manager.

Both the client inside Android app and in Termux does not have any way to detect power management. They need to be hooked up by an external handler (in the Android app, the GUI handle this; in Termux, use `termux-battery-status` provided Termux:API). An example script is provided in the repo which allows a somewhat similar behavior for Termux BOINC to Android app BOINC.

By trading the convenience of a GUI, we can have a greater flexibility in controlling Termux BOINC (like scaling the CPU work load according to battery temperature) through your own selection of scripts (bash, python, etc.).

### TODO

More TODO and citations needed.

What about `-landroid-shmem`?
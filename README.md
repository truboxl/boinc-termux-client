# boinc-termux-client

### Document prepared by [truboxl](https://github.com/truboxl)
### This document intends to provide information on how to use BOINC on Termux.

## Installation

In addition of [the official BOINC for Android app](https://play.google.com/store/apps/details?id=edu.berkeley.boinc&hl=en), Android users can install BOINC client from [Termux repo](https://github.com/termux/termux-packages/tree/master/packages/boinc). Simply install Termux from:

[Google Play](https://play.google.com/store/apps/details?id=com.termux&hl=en)

[F-Droid](https://f-droid.org/en/packages/com.termux/)

and install `boinc` using the command:

    $ pkg install boinc

Please make sure you know where you want to store the BOINC data as running a simple `boinc` can cause your home directory to be populated with unwanted files. Use `--dir` to point to a prefered location as BOINC data direcroty, example:

    $ boinc --dir ~/boincappdata

If you are a long time BOINC user, you can expect to do pretty much everything you do with BOINC on Desktop.

[`boinctui`](https://github.com/termux/termux-packages/tree/master/packages/boinctui) is also available if you want to use that.

## Platform name correction

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

Certain projects may not provide 64bit version of their project binaries. They instead chose to provide 32bit version of the binaries. To request downloading 32bit version, add the appropriate `<alt_platform>` in `cc_config.xml`. Example on an aarch64 Android device:

```
...
<alt_platform>arm-android-linux-gnu</alt_platform>
...
```

Above is only adding the request to project server. To be able to execute in Termux, you need to `unset LD_PRELOAD` before running the BOINC client. See [termux/termux-app#567](https://github.com/termux/termux-app/issues/567). You can also launch the client with support of running 32bit binaries using:

    $ LD_PRELOAD='' boinc

## Auto start BOINC at device boot

This requires Termux:Boot app. You need to install the correct version depending on the installed Termux app due to different key signing. See https://wiki.termux.com/wiki/Termux:Boot. You can install Termux:Boot from:

[Google Play](https://play.google.com/store/apps/details?id=com.termux.boot&hl=en)

[FDroid](https://f-droid.org/en/packages/com.termux.boot/)

After that, add script to `~/.termux/boot` directory (you need to create one), eg: a script name `start-boinc` with the contents below:

```
#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
LD_PRELOAD='' boinc --dir ~/boincappdir --daemon
```

TODO seems like there's `Termux-services` that maybe worth investigating and upstream the effort

## Device name change

[BOINC/boinc#3620](https://github.com/BOINC/boinc/pull/3620) recently introduced device name change feature so that users can change the default name `localhost`. This does mean you need to build BOINC from master branch until the next version release. After that you can change the device name using `cc_config.xml`. See [truboxl/boinc-termux-client#1](https://github.com/truboxl/boinc-termux-client/issues/1) for reference.

TODO add a build script that can be natively built on Termux on device

## OpenCL platform support

BOINC client can recognise your Android device's OpenCL capabilities if your device has `libOpenCL.so`. Simply add `LD_LIBRARY_PATH` with the path that can point to `libOpenCL.so`. Before doing this, verify your device if it does have the OpenCL support by running [`clinfo`](https://github.com/Oblomov/clinfo) or [`OpenCL-Z`](https://play.google.com/store/apps/details?id=com.robertwgh.opencl_z_android&hl=en). Example:

    $ LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ANDROID_ROOT}/vendor/lib64:${ANDROID_ROOT}/vendor/lib64/egl" boinc

### Note: Currently no projects that I am aware of uses OpenCL on Android devices. You don't need to do this.

## GNU/Linux platform support (EXPERIMENTAL)

Believe it or not, you can run GNU/Linux version of the project binaries on your Android device if the device architecture is the same. This is done through the use of `proot` converting certain system calls. Add the appropriate alternative platform string and run `proot boinc`. However, this is experimental.

### Note: You have to GIVE UP running the Android version of binaries if you choose to do this

### Don't mix and match Android with GNU/Linux. You can't be that greedy to run them all!

TODO GNU/Linux system calls are INCOMPATIBLE with Android system calls?

TODO binaries compiled with GNU libstdc++ may not be compatible with Android libc++?

## Platform compatibility table

<table>
<thread>
<tr>
<th>Device architecture</th><th colspan=4>Project platform (Android)</th><th colspan=4>Project platform (GNU/Linux)</th>
</tr>
</thread>
<tbody>
<tr><td></td><td>aarch64</td><td>arm</td><td>x86_64</td><td>x86</td><td>aarch64</td><td>arm</td><td>x86_64</td><td>x86</td></tr>
<tr><td>aarch64</td><td>Yes</td><td>LDP</td><td>No</td><td>No</td><td>Proot</td><td>LDP + Proot</td><td>No</td><td>No</td></tr>
<tr><td>arm*</td><td>No</td><td>Yes</td><td>No</td><td>No</td><td>No</td><td>Proot</td><td>No</td><td>No</td></tr>
<tr><td>x86_64**</td><td>?</td><td>?</td><td>Yes</td><td>LDP</td><td>?</td><td>?</td><td>Proot</td><td>LDP + Proot</td></tr>
<tr><td>x86**</td><td>?</td><td>?</td><td>No</td><td>Yes</td><td>?</td><td>?</td><td>No</td><td>Proot</td></tr>
</tbody>
</table>

Notes:
\
Yes = It works
\
No = Just No, don't say another word
\
LDP = Unset `LD_PRELOAD`
\
Proot = Prepend `proot`
\
\* = I don't have 32bit ARM devices that are new enough to run Termux. These are based on assumptions. You will be better off using official BOINC app.
\
\** = I don't have x86 devices to run Termux. These are based on assumptions.
\
? = Some x86 devices have `libhoudini.so`. I am not sure what will happen. But there will be performance issues. Generally assume No.

## Report issues

If you have read this far and plan to do this, you are really on your own. I do not think the BOINC guys endorse this nor the Termux guys able to solve whatever problems nor the project guys want to support such frankenstein platform. You can improve your findings here though. Make an issue or pull request.

## TODO

* differences between app and Termux
* pkill boinc
* lack of finer compute controls
* no thermal controls, fix Android thermal warnings?
* no idle detection
* remote monitoring and control

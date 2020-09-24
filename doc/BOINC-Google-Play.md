## BOINC on Google Play situation

Because everybody is [too busy polishing GUI](https://github.com/BOINC/boinc/pulls?q=is%3Apr+android) and do not see the underlying problem that BOINC Android app (version 7.4.53) has not been getting new updates to [Play Store](https://play.google.com/store/apps/details?id=edu.berkeley.boinc&hl=en) since [2016](https://boinc.berkeley.edu/download_all.php), I guess I have to write a post on how serious the matter is from an outsider perspective. This comes off as a rant and not to take an offense to anyone particular.

<b>Starting [2 November 2020](https://days.to/2-november/2020), Google [requires](https://developer.android.com/distribute/best-practices/develop/target-sdk) developers to make their future app updates to set `targetSdkVersion` to `29`.</b>

However, BOINC still doesn't do this as it will break code execution that BOINC has always been doing up until now, eg: download executables and project files from project server, run stuff inside app data directory, send result back to project server.

By setting `targetSdkVersion` to `29` (running on Android 10), the "run stuff inside app data directory" part will be broken as execution this way is [deemed insecure](https://issuetracker.google.com/issues/128554619#comment4) by Google. A lot of apps are affected by this including [Termux](https://github.com/termux/termux-app/issues/1072).

To address this, BOINC team attempts to do [a revamp](https://github.com/BOINC/boinc/issues/3561). However it mostly stay idle for a long time and they change priorities every time (see above).

The revamp will look something like this: app downloads executables in bundle form from Google Play instead of project server, app downloads non-executable project files from project server (maybe?), app runs the executables from bundle and act on the project files, send back the result to project server.

The revamp as I understand requires the projects to send their executables to BOINC team to make the bundle for Google Play submission. I do not think all projects want to do this. Projects may end up just forking BOINC source code and make their own client with their executables bundled and submit to Play Store.

As the deadline is looming, I expect BOINC for Android (in this current iteration) to die and delisted from Google Play.

In the future, BOINC app may need to be downloaded and installed from Berkeley website for Android 10 and older. Future Android versions may stop allow running old BOINC app altogether if Google is heading towards this trend.

For Termux version of BOINC client, I expect it to work in the future with the old BOINC way using Termux's `proot` executable loader in newer Android versions. There are still some kinks like [32bit on 64bit compatibility](https://github.com/termux/proot/issues/119) that need to be iron out first.

An alternate solution that I am looking forward to is porting to [WASM](https://github.com/BOINC/boinc/issues/3086) which may additionally allow running on iOS platforms.

Since BOINC is a community based effort, I wish more people (especially the project owners) chime in and help the team to transition faster.

Thanks for reading my rant.
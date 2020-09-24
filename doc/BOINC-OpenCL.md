## OpenCL platform support

BOINC client can recognise your Android device's OpenCL capabilities if your device has `libOpenCL.so`. Simply add `LD_LIBRARY_PATH` with the path that can point to `libOpenCL.so`. Before doing this, verify your device if it does have the OpenCL support by running [`clinfo`](https://github.com/Oblomov/clinfo) or [`OpenCL-Z`](https://play.google.com/store/apps/details?id=com.robertwgh.opencl_z_android&hl=en). Example:

    $ LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ANDROID_ROOT}/vendor/lib64:${ANDROID_ROOT}/vendor/lib64/egl" boinc

<b>Note: Currently no projects that I am aware of uses OpenCL on Android devices. You don't need to do this.</b>
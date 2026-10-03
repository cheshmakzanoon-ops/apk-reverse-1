package com.gme.liteav.base;

import com.gme.liteav.base.annotations.JNINamespace;

@JNINamespace("base::android")
public abstract class PathService {
    public static final int DIR_MODULE = 3;

    private static native void nativeOverride(int i, String str);

    private PathService() {
    }

    public static void override(int i, String str) {
        nativeOverride(i, str);
    }
}

package com.google.android.gms.common.util;

import android.os.Build;
import androidx.core.os.BuildCompat;

public final class PlatformVersion {
    private PlatformVersion() {
    }

    @Deprecated
    public static boolean isAtLeastHoneycomb() {
        return true;
    }

    @Deprecated
    public static boolean isAtLeastHoneycombMR1() {
        return true;
    }

    @Deprecated
    public static boolean isAtLeastIceCreamSandwich() {
        return true;
    }

    @Deprecated
    public static boolean isAtLeastIceCreamSandwichMR1() {
        return true;
    }

    @Deprecated
    public static boolean isAtLeastJellyBean() {
        return true;
    }

    @Deprecated
    public static boolean isAtLeastJellyBeanMR1() {
        return true;
    }

    @Deprecated
    public static boolean isAtLeastJellyBeanMR2() {
        return true;
    }

    @Deprecated
    public static boolean isAtLeastKitKat() {
        return true;
    }

    @Deprecated
    public static boolean isAtLeastKitKatWatch() {
        return true;
    }

    @Deprecated
    public static boolean isAtLeastLollipop() {
        return true;
    }

    @Deprecated
    public static boolean isAtLeastLollipopMR1() {
        return true;
    }

    @Deprecated
    public static boolean isAtLeastM() {
        return true;
    }

    public static boolean isAtLeastN() {
        return Build.VERSION.SDK_INT >= 24;
    }

    public static boolean isAtLeastO() {
        return Build.VERSION.SDK_INT >= 26;
    }

    public static boolean isAtLeastP() {
        return Build.VERSION.SDK_INT >= 28;
    }

    public static boolean isAtLeastQ() {
        return Build.VERSION.SDK_INT >= 29;
    }

    public static boolean isAtLeastR() {
        return Build.VERSION.SDK_INT >= 30;
    }

    public static boolean isAtLeastS() {
        return Build.VERSION.SDK_INT >= 31;
    }

    public static boolean isAtLeastSv2() {
        return Build.VERSION.SDK_INT >= 32;
    }

    public static boolean isAtLeastT() {
        return Build.VERSION.SDK_INT >= 33;
    }

    public static boolean isAtLeastU() {
        return Build.VERSION.SDK_INT >= 34;
    }

    public static boolean isAtLeastV() {
        return BuildCompat.isAtLeastV();
    }
}

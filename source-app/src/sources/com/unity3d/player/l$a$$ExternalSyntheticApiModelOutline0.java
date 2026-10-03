package com.unity3d.player;

import android.app.ApplicationExitInfo;
import android.app.NotificationChannel;
import android.content.res.loader.ResourcesLoader;
import android.graphics.drawable.AdaptiveIconDrawable;
import android.graphics.drawable.ColorStateListDrawable;
import dalvik.system.DelegateLastClassLoader;
import java.util.Comparator;
import java.util.PriorityQueue;

public final class l$a$$ExternalSyntheticApiModelOutline0 {
    public static ApplicationExitInfo m590m(Object obj) {
        return (ApplicationExitInfo) obj;
    }

    public static NotificationChannel m592m(String str, CharSequence charSequence, int i) {
        return new NotificationChannel(str, charSequence, i);
    }

    public static ResourcesLoader m596m() {
        return new ResourcesLoader();
    }

    public static ColorStateListDrawable m599m(Object obj) {
        return (ColorStateListDrawable) obj;
    }

    public static DelegateLastClassLoader m612m(String str, ClassLoader classLoader) {
        return new DelegateLastClassLoader(str, classLoader);
    }

    public static PriorityQueue m625m(Comparator comparator) {
        return new PriorityQueue(comparator);
    }

    public static void m626m() {
    }

    public static boolean m660m(Object obj) {
        return obj instanceof ColorStateListDrawable;
    }

    public static void m$1() {
    }

    public static boolean m$1(Object obj) {
        return obj instanceof AdaptiveIconDrawable;
    }

    public static void m$2() {
    }
}

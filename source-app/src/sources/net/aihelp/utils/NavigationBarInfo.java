package net.aihelp.utils;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.os.Build;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.ViewConfiguration;
import android.widget.ImageView;
import java.lang.reflect.Method;

public class NavigationBarInfo {
    private static final String TAG = "NavigationBarInfo";
    public static final int VIVO_FILLET = 8;
    public static final int VIVO_NOTCH = 32;

    public static int getNavigationBarHeight(Context context) {
        Resources resources;
        int identifier;
        int dimensionPixelSize = (!hasNavBar(context) || (identifier = (resources = context.getResources()).getIdentifier("navigation_bar_height", "dimen", "android")) <= 0) ? 0 : resources.getDimensionPixelSize(identifier);
        Log.e(TAG, "NavigationBarHeight = " + dimensionPixelSize);
        return dimensionPixelSize;
    }

    private static boolean hasNavBar(Context context) {
        Resources resources = context.getResources();
        int identifier = resources.getIdentifier("config_showNavigationBar", "bool", "android");
        if (identifier != 0) {
            boolean z = resources.getBoolean(identifier);
            String navBarOverride = getNavBarOverride();
            if ("1".equals(navBarOverride)) {
                return false;
            }
            if ("0".equals(navBarOverride)) {
                return true;
            }
            return z;
        }
        return !ViewConfiguration.get(context).hasPermanentMenuKey();
    }

    private static String getNavBarOverride() {
        try {
            Method declaredMethod = Class.forName("android.os.SystemProperties").getDeclaredMethod("get", String.class);
            declaredMethod.setAccessible(true);
            return (String) declaredMethod.invoke(null, "qemu.hw.mainkeys");
        } catch (Exception e) {
            Log.e(TAG, e.toString());
            return null;
        }
    }

    public static void adaptiveStartPage(Activity activity, ImageView imageView, boolean z) {
        DisplayMetrics displayMetrics = activity.getResources().getDisplayMetrics();
        float navigationBarHeight = displayMetrics.heightPixels + getNavigationBarHeight(activity);
        float f = navigationBarHeight / displayMetrics.widthPixels;
        Log.e(TAG, "heigth = " + navigationBarHeight);
        Log.e(TAG, "standard = 1.7777778");
        Log.e(TAG, "actual = " + f);
    }

    public static void hideNavigationBar(Activity activity) {
        activity.getWindow().getDecorView().setSystemUiVisibility(4102);
    }

    public static int getStatusBarHeight(Context context) {
        int identifier = context.getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (identifier > 0) {
            return context.getResources().getDimensionPixelSize(identifier);
        }
        return 0;
    }

    public static boolean hasNotchScreen(Activity activity) {
        return getInt("ro.miui.notch", activity) || hasNotchAtHuawei(activity) || hasNotchAtOPPO(activity) || hasNotchAtVivo(activity);
    }

    public static boolean getInt(String str, Activity activity) {
        int iIntValue;
        if (isXiaomi()) {
            try {
                Class<?> clsLoadClass = activity.getClassLoader().loadClass("android.os.SystemProperties");
                iIntValue = ((Integer) clsLoadClass.getMethod("getInt", String.class, Integer.TYPE).invoke(clsLoadClass, str, 0)).intValue();
            } catch (Exception e) {
                e.printStackTrace();
                iIntValue = 0;
            }
        } else {
            iIntValue = 0;
        }
        return iIntValue == 1;
    }

    public static boolean hasNotchAtHuawei(Context context) {
        try {
            Class<?> clsLoadClass = context.getClassLoader().loadClass("com.huawei.android.util.HwNotchSizeUtil");
            return ((Boolean) clsLoadClass.getMethod("hasNotchInScreen", null).invoke(clsLoadClass, null)).booleanValue();
        } catch (ClassNotFoundException unused) {
            Log.e(TAG, "hasNotchAtHuawei ClassNotFoundException");
            return false;
        } catch (NoSuchMethodException unused2) {
            Log.e(TAG, "hasNotchAtHuawei NoSuchMethodException");
            return false;
        } catch (Exception unused3) {
            Log.e(TAG, "hasNotchAtHuawei Exception");
            return false;
        }
    }

    public static int[] getNotchSize(Context context) {
        int[] iArr = {0, 0};
        try {
            try {
                Class<?> clsLoadClass = context.getClassLoader().loadClass("com.huawei.android.util.HwNotchSizeUtil");
                return (int[]) clsLoadClass.getMethod("getNotchSize", null).invoke(clsLoadClass, null);
            } catch (Exception unused) {
                Log.e(TAG, "getNotchSize Exception");
                return iArr;
            }
        } catch (Throwable unused2) {
            return iArr;
        }
    }

    public static boolean hasNotchAtVivo(Context context) {
        try {
            try {
                try {
                    try {
                        Class<?> clsLoadClass = context.getClassLoader().loadClass("android.util.FtFeature");
                        return ((Boolean) clsLoadClass.getMethod("isFeatureSupport", Integer.TYPE).invoke(clsLoadClass, 32)).booleanValue();
                    } catch (Exception unused) {
                        Log.e(TAG, "hasNotchAtVivo Exception");
                        return false;
                    }
                } catch (NoSuchMethodException unused2) {
                    Log.e(TAG, "hasNotchAtVivo NoSuchMethodException");
                    return false;
                }
            } catch (ClassNotFoundException unused3) {
                Log.e(TAG, "hasNotchAtVivo ClassNotFoundException");
                return false;
            }
        } catch (Throwable unused4) {
            return false;
        }
    }

    public static boolean hasNotchAtOPPO(Context context) {
        return context.getPackageManager().hasSystemFeature("com.oppo.feature.screen.heteromorphism");
    }

    public static boolean isXiaomi() {
        return "Xiaomi".equals(Build.MANUFACTURER);
    }

    public static boolean isHuawei() {
        return "Huawei".equals(Build.MANUFACTURER);
    }

    public static boolean isOppo() {
        return "Oppo".equals(Build.MANUFACTURER);
    }

    public static boolean isVivo() {
        return "Vivo".equals(Build.MANUFACTURER);
    }

    public static int getXiaomiNotchHight(Activity activity) {
        int identifier = activity.getResources().getIdentifier("notch_height", "dimen", "android");
        if (identifier > 0) {
            return activity.getResources().getDimensionPixelSize(identifier);
        }
        return 0;
    }

    public static float getHeight(Activity activity) {
        float f;
        int xiaomiNotchHight;
        DisplayMetrics displayMetrics = activity.getResources().getDisplayMetrics();
        if (hasNotchScreen(activity)) {
            if (isHuawei()) {
                xiaomiNotchHight = getNotchSize(activity)[1];
            } else {
                if (isXiaomi() || isVivo() || isOppo()) {
                    xiaomiNotchHight = getXiaomiNotchHight(activity);
                } else {
                    f = 0.0f;
                }
                return (displayMetrics.heightPixels + getNavigationBarHeight(activity)) - f;
            }
            f = xiaomiNotchHight;
            return (displayMetrics.heightPixels + getNavigationBarHeight(activity)) - f;
        }
        return displayMetrics.heightPixels + getNavigationBarHeight(activity);
    }
}

package com.gme.liteav.base.system;

import android.content.Context;
import android.content.pm.PackageInfo;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.util.C1059k;

final class C1025a {

    private static final C1059k<PackageInfo> f716a = new C1059k<>(CallableC1026b.m971a());

    static PackageInfo m970d() throws Exception {
        Context applicationContext = ContextUtils.getApplicationContext();
        if (applicationContext == null) {
            return null;
        }
        return applicationContext.getPackageManager().getPackageInfo(applicationContext.getPackageName(), 0);
    }

    public static String m967a() {
        PackageInfo packageInfoM1027a = f716a.m1027a();
        if (packageInfoM1027a == null) {
            return "";
        }
        return packageInfoM1027a.packageName;
    }

    public static String m968b() {
        PackageInfo packageInfoM1027a;
        Context applicationContext = ContextUtils.getApplicationContext();
        if (applicationContext == null || (packageInfoM1027a = f716a.m1027a()) == null) {
            return "";
        }
        return applicationContext.getPackageManager().getApplicationLabel(packageInfoM1027a.applicationInfo).toString();
    }

    public static String m969c() {
        PackageInfo packageInfoM1027a = f716a.m1027a();
        if (packageInfoM1027a == null) {
            return "";
        }
        return packageInfoM1027a.versionName;
    }
}

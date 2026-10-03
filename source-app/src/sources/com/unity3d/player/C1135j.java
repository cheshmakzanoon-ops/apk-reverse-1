package com.unity3d.player;

import android.app.Activity;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.pm.PackageItemInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;

public final class C1135j implements InterfaceC1132g {
    private static boolean m571a(PackageItemInfo packageItemInfo) {
        try {
            return packageItemInfo.metaData.getBoolean("unityplayer.SkipPermissionsDialog");
        } catch (Exception unused) {
            return false;
        }
    }

    @Override
    public final void mo569a(Activity activity, String str) {
        if (activity == null || str == null) {
            return;
        }
        FragmentManager fragmentManager = activity.getFragmentManager();
        if (fragmentManager.findFragmentByTag("96489") == null) {
            FragmentC1136k fragmentC1136k = new FragmentC1136k();
            Bundle bundle = new Bundle();
            bundle.putString("PermissionNames", str);
            fragmentC1136k.setArguments(bundle);
            FragmentTransaction fragmentTransactionBeginTransaction = fragmentManager.beginTransaction();
            fragmentTransactionBeginTransaction.add(0, fragmentC1136k, "96489");
            fragmentTransactionBeginTransaction.commit();
        }
    }

    @Override
    public final boolean mo570a(Activity activity) {
        try {
            PackageManager packageManager = activity.getPackageManager();
            return m571a(packageManager.getActivityInfo(activity.getComponentName(), 128)) || m571a(packageManager.getApplicationInfo(activity.getPackageName(), 128));
        } catch (Exception unused) {
            return false;
        }
    }
}

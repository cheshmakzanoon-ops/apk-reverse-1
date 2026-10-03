package net.aihelp.core.p004ui.glide.signature;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import j$.util.concurrent.ConcurrentHashMap;
import java.util.UUID;
import net.aihelp.core.p004ui.glide.load.Key;

public final class ApplicationVersionSignature {
    private static final ConcurrentHashMap<String, Key> PACKAGE_NAME_TO_KEY = new ConcurrentHashMap<>();

    public static Key obtain(Context context) {
        String packageName = context.getPackageName();
        ConcurrentHashMap<String, Key> concurrentHashMap = PACKAGE_NAME_TO_KEY;
        Key key = (Key) concurrentHashMap.get(packageName);
        if (key != null) {
            return key;
        }
        Key keyObtainVersionSignature = obtainVersionSignature(context);
        Key key2 = (Key) concurrentHashMap.putIfAbsent(packageName, keyObtainVersionSignature);
        return key2 == null ? keyObtainVersionSignature : key2;
    }

    static void reset() {
        PACKAGE_NAME_TO_KEY.clear();
    }

    private static Key obtainVersionSignature(Context context) {
        PackageInfo packageInfo;
        String string;
        try {
            packageInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            packageInfo = null;
        }
        if (packageInfo != null) {
            string = String.valueOf(packageInfo.versionCode);
        } else {
            string = UUID.randomUUID().toString();
        }
        return new StringSignature(string);
    }

    private ApplicationVersionSignature() {
    }
}

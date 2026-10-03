package com.gme.liteav.audio2.permission;

import android.os.Process;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.system.LiteavSystemInfo;
import java.util.ArrayList;
import java.util.List;

@JNINamespace("liteav::audio")
public class PermissionRequesterAndroid extends PermissionActivity.AbstractC0996a {
    private static final String TAG = "PermissionRequesterAndroid";
    private static final List<String> mRequestedPermissions = new ArrayList();
    private final long mNativePermissionRequesterAndroid;

    private static native void nativeNotifyPermissionsResultFromJava(long j, boolean z);

    public PermissionRequesterAndroid(long j) {
        this.mNativePermissionRequesterAndroid = j;
    }

    public void requestPermission(String str) {
        if (str == null || str.isEmpty()) {
            Log.m951w(TAG, "request permission is null.", new Object[0]);
            return;
        }
        if (LiteavSystemInfo.getSystemOSVersionInt() < 23) {
            handleRequestPermissionsResult(new String[]{str});
            return;
        }
        List<String> list = mRequestedPermissions;
        if (list.contains(str)) {
            handleRequestPermissionsResult((String[]) list.toArray(new String[0]));
        } else {
            PermissionActivity.m935a(ContextUtils.getApplicationContext(), new String[]{str}, this);
        }
    }

    @Override
    public void onRequestPermissionsResult(String[] strArr, int[] iArr) {
        handleRequestPermissionsResult(strArr);
        for (String str : strArr) {
            List<String> list = mRequestedPermissions;
            if (!list.contains(str)) {
                list.add(str);
            }
        }
    }

    private boolean hasPermission(String str) {
        if (str == null || str.isEmpty()) {
            Log.m951w(TAG, "check permission is null.", new Object[0]);
            return true;
        }
        try {
            return LiteavSystemInfo.getSystemOSVersionInt() < 23 || ContextUtils.getApplicationContext().checkPermission(str, Process.myPid(), Process.myUid()) == 0;
        } catch (Throwable th) {
            Log.m948e(TAG, "check permission exception, " + th.getMessage(), new Object[0]);
            return true;
        }
    }

    private void handleRequestPermissionsResult(String[] strArr) {
        for (String str : strArr) {
            nativeNotifyPermissionsResultFromJava(this.mNativePermissionRequesterAndroid, hasPermission(str));
        }
    }
}

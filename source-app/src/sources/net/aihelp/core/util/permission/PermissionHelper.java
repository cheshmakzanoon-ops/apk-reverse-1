package net.aihelp.core.util.permission;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.net.Uri;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;
import java.lang.reflect.Method;
import net.aihelp.config.AIHelpContext;

public class PermissionHelper implements IPermissionCallback {
    private int invokeId = -1;
    private Object object;
    private final String[] permissions;
    private final int requestCode;
    private final int requestType;

    @Override
    public void onPermissionDenied() {
    }

    private PermissionHelper(Object obj, String[] strArr, int i, int i2) {
        this.object = obj;
        this.permissions = strArr;
        this.requestCode = i;
        this.requestType = i2;
    }

    public static PermissionHelper getInstance(Object obj, String[] strArr, int i, int i2) {
        if (obj == null || strArr == null || i == 0) {
            throw new IllegalArgumentException("mObject == null || permission == null || requestCode == 0!");
        }
        return new PermissionHelper(obj, strArr, i, i2);
    }

    public void setInvokeId(int i) {
        this.invokeId = i;
    }

    public boolean avoidInvoking() {
        return this.invokeId == this.requestCode;
    }

    void invokePermissionCallback(Permission.Result result) {
        if (avoidInvoking()) {
            return;
        }
        for (Method method : this.object.getClass().getDeclaredMethods()) {
            Permission permission = (Permission) method.getAnnotation(Permission.class);
            if (permission != null && this.requestCode == permission.requestCode()) {
                method.setAccessible(true);
                try {
                    method.invoke(this.object, result, this, Integer.valueOf(this.requestType));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private boolean isPermissionGranted(String str) {
        return getActivity() != null && ContextCompat.checkSelfPermission(getActivity(), str) == 0;
    }

    private Activity getActivity() {
        Object obj = this.object;
        if (obj instanceof Activity) {
            return (Activity) obj;
        }
        if (obj instanceof Fragment) {
            return ((Fragment) obj).getActivity();
        }
        return null;
    }

    void onRequestPermissionsResult(String[] strArr, int[] iArr) {
        setInvokeId(-1);
        for (int i = 0; i < iArr.length; i++) {
            if (iArr[i] == 0) {
                invokePermissionCallback(Permission.Result.GRANTED);
            } else if (shouldShowRequestPermissionRationale(strArr[i])) {
                invokePermissionCallback(Permission.Result.DENIED);
            } else {
                invokePermissionCallback(Permission.Result.GO_SETTING);
            }
            setInvokeId(this.requestCode);
        }
    }

    Permission.State[] checkPermissionState() {
        Permission.State state;
        Permission.State[] stateArr = new Permission.State[this.permissions.length];
        int i = 0;
        while (true) {
            String[] strArr = this.permissions;
            if (i >= strArr.length) {
                return stateArr;
            }
            String str = strArr[i];
            if (isPermissionGranted(str)) {
                state = Permission.State.AVAILABLE;
            } else if (hasPermissionInManifest(str)) {
                state = Permission.State.ASKABLE;
                if (shouldShowRequestPermissionRationale(str)) {
                    state = Permission.State.RATIONAL;
                }
            } else {
                state = Permission.State.UNAVAILABLE;
            }
            stateArr[i] = state;
            i++;
        }
    }

    void requestPermission() {
        Object obj = this.object;
        if (obj instanceof Activity) {
            ActivityCompat.requestPermissions((Activity) obj, this.permissions, this.requestCode);
        } else if (obj instanceof Fragment) {
            Fragment fragment = (Fragment) obj;
            if (fragment.isDetached()) {
                return;
            }
            fragment.requestPermissions(this.permissions, this.requestCode);
        }
    }

    private boolean shouldShowRequestPermissionRationale(String str) {
        Object obj = this.object;
        if (obj instanceof Activity) {
            return ((Activity) this.object).shouldShowRequestPermissionRationale(str);
        }
        if (!(obj instanceof Fragment)) {
            return false;
        }
        Fragment fragment = (Fragment) obj;
        if (fragment.isDetached()) {
            return false;
        }
        return fragment.shouldShowRequestPermissionRationale(str);
    }

    private static boolean hasPermissionInManifest(String str) {
        try {
            Context context = AIHelpContext.getInstance().getContext();
            PackageInfo packageInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), 4096);
            if (packageInfo.requestedPermissions != null) {
                for (String str2 : packageInfo.requestedPermissions) {
                    if (str2.equals(str)) {
                        return true;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private void showSettingsPage() {
        Activity activity = getActivity();
        if (activity != null) {
            try {
                Intent intent = new Intent("android.settings.APPLICATION_DETAILS_SETTINGS");
                intent.addCategory("android.intent.category.DEFAULT");
                intent.setData(Uri.parse("package:" + activity.getPackageName()));
                activity.startActivity(intent);
            } catch (ActivityNotFoundException unused) {
                Intent intent2 = new Intent("android.settings.MANAGE_APPLICATIONS_SETTINGS");
                intent2.addCategory("android.intent.category.DEFAULT");
                activity.startActivity(intent2);
            }
        }
    }

    public void recycle() {
        this.object = null;
    }

    @Override
    public void onPermissionRational() {
        requestPermission();
    }

    @Override
    public void onPermissionIgnored() {
        showSettingsPage();
    }
}

package net.aihelp.core.util.permission;

import android.content.Context;

public class AIHelpPermissions {
    private static AIHelpPermissions sInstance;
    private PermissionHelper helper;
    private Object object;
    private String[] permissions;
    private int requestCode = 0;

    private AIHelpPermissions() {
    }

    public AIHelpPermissions setHost(Object obj) {
        this.object = obj;
        return this;
    }

    public AIHelpPermissions setRequestPermission(String... strArr) {
        this.permissions = strArr;
        return this;
    }

    public AIHelpPermissions setRequestCode(int i) {
        this.requestCode = i;
        return this;
    }

    public void request(Context context, int i) {
        PermissionHelper permissionHelper = PermissionHelper.getInstance(this.object, this.permissions, this.requestCode, i);
        this.helper = permissionHelper;
        for (Permission.State state : permissionHelper.checkPermissionState()) {
            int i2 = C06371.$SwitchMap$net$aihelp$core$util$permission$Permission$State[state.ordinal()];
            if (i2 == 1) {
                this.helper.invokePermissionCallback(Permission.Result.GRANTED);
            } else if (i2 == 2) {
                this.helper.invokePermissionCallback(Permission.Result.NONE);
            } else if (i2 == 3) {
                this.helper.invokePermissionCallback(Permission.Result.RATIONAL);
            } else if (i2 == 4) {
                RequestAlertHelper.request(context, this.helper);
            }
            this.helper.setInvokeId(this.requestCode);
        }
    }

    static class C06371 {
        static final int[] $SwitchMap$net$aihelp$core$util$permission$Permission$State;

        static {
            int[] iArr = new int[Permission.State.values().length];
            $SwitchMap$net$aihelp$core$util$permission$Permission$State = iArr;
            try {
                iArr[Permission.State.AVAILABLE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                $SwitchMap$net$aihelp$core$util$permission$Permission$State[Permission.State.UNAVAILABLE.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                $SwitchMap$net$aihelp$core$util$permission$Permission$State[Permission.State.RATIONAL.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                $SwitchMap$net$aihelp$core$util$permission$Permission$State[Permission.State.ASKABLE.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
        }
    }

    public void onRequestPermissionsResult(String[] strArr, int[] iArr) {
        PermissionHelper permissionHelper = this.helper;
        if (permissionHelper != null) {
            permissionHelper.onRequestPermissionsResult(strArr, iArr);
        }
    }

    public void recycle() {
        this.object = null;
        PermissionHelper permissionHelper = this.helper;
        if (permissionHelper != null) {
            permissionHelper.recycle();
            this.helper = null;
        }
    }

    public static AIHelpPermissions getInstance() {
        if (sInstance == null) {
            synchronized (PermissionHelper.class) {
                if (sInstance == null) {
                    sInstance = new AIHelpPermissions();
                }
            }
        }
        return sInstance;
    }
}

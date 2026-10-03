package com.gme.liteav.audio2.permission;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.system.LiteavSystemInfo;
import com.gme.liteav.base.util.C1053e;
import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

public class PermissionActivity extends Activity {

    private static final Map<PermissionActivity, AbstractC0996a> f590a = new HashMap();

    public static abstract class AbstractC0996a implements Serializable {
        public void onRequestPermissionsResult(String[] strArr, int[] iArr) {
        }
    }

    static void m935a(Context context, String[] strArr, AbstractC0996a abstractC0996a) {
        try {
            Intent intent = new Intent(context, (Class<?>) PermissionActivity.class);
            intent.putExtra("KEY_PERMISSIONS", strArr);
            intent.putExtra("KEY_CALLBACK", abstractC0996a);
            intent.addFlags(268435456);
            context.startActivity(intent);
        } catch (Throwable th) {
            Log.m948e("PermissionActivity", "start activity failed. ".concat(String.valueOf(th)), new Object[0]);
            try {
                Activity activityM1020c = C1053e.m1011a().m1020c();
                if (activityM1020c != null) {
                    activityM1020c.requestPermissions(strArr, 1000);
                    abstractC0996a.onRequestPermissionsResult(strArr, new int[1]);
                }
            } catch (Throwable th2) {
                Log.m948e("PermissionActivity", "requestPermissions failed. ".concat(String.valueOf(th2)), new Object[0]);
            }
        }
    }

    @Override
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        if (bundle != null) {
            return;
        }
        try {
            Intent intent = getIntent();
            f590a.put(this, (AbstractC0996a) intent.getSerializableExtra("KEY_CALLBACK"));
            String[] stringArrayExtra = intent.getStringArrayExtra("KEY_PERMISSIONS");
            if (LiteavSystemInfo.getSystemOSVersionInt() >= 23) {
                requestPermissions(stringArrayExtra, 1000);
            }
        } catch (Throwable th) {
            Log.m948e("PermissionActivity", "requestPermissions failed. ".concat(String.valueOf(th)), new Object[0]);
        }
    }

    @Override
    public void onRequestPermissionsResult(int i, String[] strArr, int[] iArr) {
        AbstractC0996a abstractC0996a = f590a.get(this);
        if (abstractC0996a == null) {
            return;
        }
        abstractC0996a.onRequestPermissionsResult(strArr, iArr);
        finish();
    }
}

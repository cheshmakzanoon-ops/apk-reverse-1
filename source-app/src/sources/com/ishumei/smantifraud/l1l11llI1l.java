package com.ishumei.smantifraud;

import android.content.ContentProviderClient;
import android.content.Context;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;

public class l1l11llI1l extends l1l11lI11l {
    public final Context l111l11111lIl;

    public l1l11llI1l(Context context) {
        this.l111l11111lIl = context;
    }

    public static boolean l1111l111111Il(Context context) {
        try {
            Uri uri = Uri.parse("content://cn.nubia.identity/identity");
            int i = Build.VERSION.SDK_INT;
            ContentProviderClient contentProviderClientAcquireContentProviderClient = context.getContentResolver().acquireContentProviderClient(uri);
            if (contentProviderClientAcquireContentProviderClient == null) {
                return false;
            }
            contentProviderClientAcquireContentProviderClient.release();
            return true;
        } catch (Throwable unused) {
            return false;
        }
    }

    @Override
    public String l1111l111111Il() {
        Uri uri = Uri.parse("content://cn.nubia.identity/identity");
        try {
            int i = Build.VERSION.SDK_INT;
            ContentProviderClient contentProviderClientAcquireContentProviderClient = this.l111l11111lIl.getContentResolver().acquireContentProviderClient(uri);
            Bundle bundleCall = null;
            if (contentProviderClientAcquireContentProviderClient != null) {
                bundleCall = contentProviderClientAcquireContentProviderClient.call("getOAID", null, null);
                contentProviderClientAcquireContentProviderClient.release();
            }
            return (bundleCall != null ? bundleCall.getInt("code", -1) : -1) == 0 ? bundleCall.getString("id") : "";
        } catch (Exception unused) {
            return "";
        }
    }
}

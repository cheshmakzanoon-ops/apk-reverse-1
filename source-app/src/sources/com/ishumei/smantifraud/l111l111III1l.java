package com.ishumei.smantifraud;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;

public class l111l111III1l {
    public static boolean l111l11111I1l;
    public final Context l1111l111111Il;
    public final ServiceConnection l111l11111lIl = new l1111l111111Il();

    public class l1111l111111Il implements ServiceConnection {
        public l1111l111111Il() {
        }

        @Override
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            boolean unused = l111l111III1l.l111l11111I1l = true;
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {
        }
    }

    public l111l111III1l(Context context) {
        this.l1111l111111Il = context;
    }

    public void l1111l111111Il() {
        try {
            Intent intent = new Intent();
            intent.setPackage("com.bmy.bimuyu");
            intent.setComponent(new ComponentName("com.android.keychain", "com.android.keychain.wgserver.wgService"));
            this.l1111l111111Il.bindService(intent, this.l111l11111lIl, 1);
        } catch (Throwable unused) {
        }
    }

    public void l111l11111I1l() {
        try {
            this.l1111l111111Il.unbindService(this.l111l11111lIl);
        } catch (Throwable unused) {
        }
    }

    public boolean l111l11111lIl() {
        return l111l11111I1l;
    }
}

package com.unity3d.player;

import android.app.Activity;
import android.content.Context;
import android.os.Looper;
import java.util.concurrent.Semaphore;
import java.util.concurrent.TimeUnit;

class C1129d {

    protected InterfaceC1133h f442b;

    protected String f445e;

    protected C1143r f441a = null;

    protected Context f443c = null;

    protected String f444d = null;

    C1129d(String str, InterfaceC1133h interfaceC1133h) {
        this.f445e = str;
        this.f442b = interfaceC1133h;
    }

    protected void reportError(String str) {
        InterfaceC1133h interfaceC1133h = this.f442b;
        if (interfaceC1133h != null) {
            interfaceC1133h.reportError(this.f445e + " Error [" + this.f444d + "]", str);
            return;
        }
        C1134i.Log(6, this.f445e + " Error [" + this.f444d + "]: " + str);
    }

    protected void runOnUiThread(Runnable runnable) {
        Context context = this.f443c;
        if (context instanceof Activity) {
            ((Activity) context).runOnUiThread(runnable);
            return;
        }
        C1134i.Log(5, "Not running " + this.f445e + " from an Activity; Ignoring execution request...");
    }

    protected boolean runOnUiThreadWithSync(final Runnable runnable) {
        boolean z = true;
        if (Looper.getMainLooper().getThread() == Thread.currentThread()) {
            runnable.run();
            return true;
        }
        final Semaphore semaphore = new Semaphore(0);
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                try {
                    try {
                        runnable.run();
                    } catch (Exception e) {
                        C1129d.this.reportError("Exception unloading Google VR on UI Thread. " + e.getLocalizedMessage());
                    }
                } finally {
                    semaphore.release();
                }
            }
        });
        try {
            if (!semaphore.tryAcquire(4L, TimeUnit.SECONDS)) {
                reportError("Timeout waiting for vr state change!");
                z = false;
            }
            return z;
        } catch (InterruptedException e) {
            reportError("Interrupted while trying to acquire sync lock. " + e.getLocalizedMessage());
            return false;
        }
    }
}

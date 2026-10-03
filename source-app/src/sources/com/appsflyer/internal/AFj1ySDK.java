package com.appsflyer.internal;

import android.content.Context;
import java.lang.ref.WeakReference;

public final class AFj1ySDK {
    public String AFKeystoreWrapper;
    public final WeakReference<Context> valueOf;

    public AFj1ySDK(Context context) {
        this.valueOf = new WeakReference<>(context);
    }
}

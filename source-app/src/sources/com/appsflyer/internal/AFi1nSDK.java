package com.appsflyer.internal;

import android.content.Context;
import com.facebook.share.internal.ShareConstants;
import java.util.HashMap;
import java.util.Map;
import java.util.Observable;
import java.util.Observer;

public abstract class AFi1nSDK extends Observable {
    public final String AFInAppEventParameterName;
    final Runnable AFInAppEventType;
    public final String AFLogger;

    long f408d;
    public final Map<String, Object> values = new HashMap();
    public AFa1uSDK unregisterClient = AFa1uSDK.NOT_STARTED;

    public enum AFa1uSDK {
        NOT_STARTED,
        STARTED,
        FINISHED
    }

    public abstract void values(Context context);

    public AFi1nSDK(String str, String str2, Runnable runnable) {
        this.AFInAppEventType = runnable;
        this.AFInAppEventParameterName = str2;
        this.AFLogger = str;
    }

    final class C08753 implements Observer {
        C08753() {
        }

        @Override
        public final void update(Observable observable, Object obj) {
            AFi1nSDK.this.AFInAppEventType.run();
        }
    }

    public final void AFInAppEventType() {
        this.values.put(ShareConstants.FEED_SOURCE_PARAM, this.AFInAppEventParameterName);
        this.values.put("type", this.AFLogger);
        this.values.put("latency", Long.valueOf(System.currentTimeMillis() - this.f408d));
        this.unregisterClient = AFa1uSDK.FINISHED;
        setChanged();
        notifyObservers();
    }
}

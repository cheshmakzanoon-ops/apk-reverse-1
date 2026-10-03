package cn.thinkingdata.android;

import android.app.Activity;
import android.app.Dialog;
import android.app.Fragment;
import android.view.View;
import android.webkit.WebView;
import cn.thinkingdata.android.utils.C0756g;
import cn.thinkingdata.android.utils.C0766q;
import java.util.Iterator;
import java.util.List;
import org.json.JSONObject;

class C0729f extends ThinkingAnalyticsSDK {

    private String f190a;

    private String f191b;

    private final JSONObject f192c;

    private boolean f193d;

    static class a {

        static final int[] f194a;

        static {
            int[] iArr = new int[ThinkingAnalyticsSDK.TATrackStatus.values().length];
            f194a = iArr;
            try {
                iArr[ThinkingAnalyticsSDK.TATrackStatus.PAUSE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                f194a[ThinkingAnalyticsSDK.TATrackStatus.STOP.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                f194a[ThinkingAnalyticsSDK.TATrackStatus.SAVE_ONLY.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                f194a[ThinkingAnalyticsSDK.TATrackStatus.NORMAL.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
        }
    }

    C0729f(TDConfig tDConfig) {
        super(tDConfig, true);
        this.f193d = true;
        this.f192c = new JSONObject();
    }

    @Override
    public void clearSuperProperties() {
        if (hasDisabled()) {
            return;
        }
        synchronized (this.f192c) {
            Iterator<String> itKeys = this.f192c.keys();
            while (itKeys.hasNext()) {
                itKeys.next();
                itKeys.remove();
            }
        }
    }

    @Override
    public void enableAutoTrack(List<ThinkingAnalyticsSDK.AutoTrackEventType> list) {
    }

    @Override
    public void enableTracking(boolean z) {
        this.f193d = z;
    }

    @Override
    public String getDistinctId() {
        String str = this.f190a;
        return str != null ? str : getRandomID();
    }

    @Override
    String getLoginId() {
        return this.f191b;
    }

    @Override
    public JSONObject getSuperProperties() {
        return this.f192c;
    }

    @Override
    public boolean hasOptOut() {
        return false;
    }

    @Override
    public void identify(String str) {
        this.f190a = str;
    }

    @Override
    public void ignoreAutoTrackActivities(List<Class<?>> list) {
    }

    @Override
    public void ignoreAutoTrackActivity(Class<?> cls) {
    }

    @Override
    public void ignoreView(View view) {
    }

    @Override
    public void ignoreViewType(Class cls) {
    }

    @Override
    public boolean isEnabled() {
        return this.f193d;
    }

    @Override
    public void login(String str) {
        if (hasDisabled()) {
            return;
        }
        this.f191b = str;
    }

    @Override
    public void logout() {
        if (hasDisabled()) {
            return;
        }
        this.f191b = null;
    }

    @Override
    public void optInTracking() {
    }

    @Override
    public void optOutTracking() {
    }

    @Override
    public void optOutTrackingAndDeleteUser() {
    }

    @Override
    public void setJsBridge(WebView webView) {
    }

    @Override
    public void setJsBridgeForX5WebView(Object obj) {
    }

    @Override
    public void setNetworkType(ThinkingAnalyticsSDK.ThinkingdataNetworkType thinkingdataNetworkType) {
    }

    @Override
    public void setSuperProperties(JSONObject jSONObject) {
        if (hasDisabled() || jSONObject == null) {
            return;
        }
        try {
            if (C0756g.m705a(jSONObject)) {
                synchronized (this.f192c) {
                    try {
                        C0766q.m747a(jSONObject, this.f192c, this.mConfig.getDefaultTimeZone());
                    } catch (Throwable th) {
                        throw th;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void setTrackStatus(ThinkingAnalyticsSDK.TATrackStatus tATrackStatus) {
        int i = a.f194a[tATrackStatus.ordinal()];
        if (i == 1) {
            this.mMessages.m451a(getToken(), false);
            enableTracking(false);
            return;
        }
        if (i == 2) {
            this.f193d = true;
            this.mMessages.m451a(getToken(), false);
            optOutTracking();
        } else if (i == 3) {
            this.f193d = true;
            this.mMessages.m451a(getToken(), true);
        } else {
            if (i != 4) {
                return;
            }
            this.f193d = true;
            this.mMessages.m451a(getToken(), false);
            flush();
        }
    }

    @Override
    public void setViewID(Dialog dialog, String str) {
    }

    @Override
    public void setViewID(View view, String str) {
    }

    @Override
    public void setViewProperties(View view, JSONObject jSONObject) {
    }

    @Override
    public void trackFragmentAppViewScreen() {
    }

    @Override
    public void trackViewScreen(Activity activity) {
    }

    @Override
    public void trackViewScreen(Fragment fragment) {
    }

    @Override
    public void trackViewScreen(Object obj) {
    }

    @Override
    public void unsetSuperProperty(String str) {
        if (hasDisabled() || str == null) {
            return;
        }
        try {
            synchronized (this.f192c) {
                try {
                    this.f192c.remove(str);
                } catch (Throwable th) {
                    throw th;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

package cn.thinkingdata.android;

import android.text.TextUtils;
import android.webkit.JavascriptInterface;
import cn.thinkingdata.android.utils.TDLog;
import org.json.JSONException;
import org.json.JSONObject;

public class TDWebAppInterface {
    private static final String TAG = "ThinkingAnalytics.TDWebAppInterface";
    private final ThinkingAnalyticsSDK defaultInstance;

    class C0705a implements ThinkingAnalyticsSDK.InterfaceC0708b {

        final String f117a;

        final C0706b f118b;

        final String f119c;

        C0705a(TDWebAppInterface tDWebAppInterface, String str, C0706b c0706b, String str2) {
            this.f117a = str;
            this.f118b = c0706b;
            this.f119c = str2;
        }

        @Override
        public void mo435a(ThinkingAnalyticsSDK thinkingAnalyticsSDK) {
            if (thinkingAnalyticsSDK.getToken().equals(this.f117a)) {
                this.f118b.m437b();
                thinkingAnalyticsSDK.trackFromH5(this.f119c);
            }
        }
    }

    private class C0706b {

        private boolean f120a;

        private C0706b(TDWebAppInterface tDWebAppInterface) {
        }

        C0706b(TDWebAppInterface tDWebAppInterface, C0705a c0705a) {
            this(tDWebAppInterface);
        }

        boolean m436a() {
            return !this.f120a;
        }

        void m437b() {
            this.f120a = true;
        }
    }

    TDWebAppInterface(ThinkingAnalyticsSDK thinkingAnalyticsSDK) {
        this.defaultInstance = thinkingAnalyticsSDK;
    }

    @JavascriptInterface
    public void thinkingdata_track(String str) {
        if (TextUtils.isEmpty(str)) {
            return;
        }
        TDLog.m679d(TAG, str);
        try {
            String string = new JSONObject(str).getString("#app_id");
            C0706b c0706b = new C0706b(this, null);
            ThinkingAnalyticsSDK.allInstances(new C0705a(this, string, c0706b, str));
            if (c0706b.m436a()) {
                this.defaultInstance.trackFromH5(str);
            }
        } catch (JSONException e) {
            TDLog.m687w(TAG, "Unexpected exception occurred: " + e.toString());
        }
    }
}

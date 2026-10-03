package com.appsflyer.share;

import android.content.Context;
import androidx.webkit.ProxyConfig;
import com.appsflyer.AFInAppEventParameterName;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.AppsFlyerProperties;
import com.appsflyer.CreateOneLinkHttpTask;
import com.appsflyer.internal.AFb1aSDK;
import com.appsflyer.internal.AFb1vSDK;
import com.appsflyer.internal.AFd1nSDK;
import com.appsflyer.internal.AFe1dSDK;
import com.appsflyer.internal.AFe1dSDK.RunnableC08534;
import com.appsflyer.internal.AFf1uSDK;
import com.appsflyer.internal.AFj1zSDK;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class LinkGenerator {
    String AFInAppEventParameterName;
    String AFInAppEventType;
    private final String AFKeystoreWrapper;
    private String AFLogger;

    private String f420d;

    private String f421e;
    private final Map<String, String> force = new HashMap();

    private String f422i;
    private String registerClient;
    private String unregisterClient;
    private String valueOf;
    private String values;

    private String f423w;

    public interface ResponseListener {
        void onResponse(String str);

        void onResponseError(String str);
    }

    public LinkGenerator(String str) {
        this.AFKeystoreWrapper = str;
    }

    public LinkGenerator setBrandDomain(String str) {
        this.f423w = str;
        return this;
    }

    public String getBrandDomain() {
        return this.f423w;
    }

    public LinkGenerator setDeeplinkPath(String str) {
        this.f420d = str;
        return this;
    }

    public LinkGenerator setBaseDeeplink(String str) {
        this.f422i = str;
        return this;
    }

    public String getChannel() {
        return this.values;
    }

    public LinkGenerator setChannel(String str) {
        this.values = str;
        return this;
    }

    public LinkGenerator setReferrerCustomerId(String str) {
        this.registerClient = str;
        return this;
    }

    public String getMediaSource() {
        return this.AFKeystoreWrapper;
    }

    public Map<String, String> getUserParams() {
        return new HashMap(this.force);
    }

    public String getCampaign() {
        return this.valueOf;
    }

    public LinkGenerator setCampaign(String str) {
        this.valueOf = str;
        return this;
    }

    public LinkGenerator addParameter(String str, String str2) {
        this.force.put(str, str2);
        return this;
    }

    public LinkGenerator addParameters(Map<String, String> map) {
        if (map != null) {
            this.force.putAll(map);
        }
        return this;
    }

    public LinkGenerator setReferrerUID(String str) {
        this.f421e = str;
        return this;
    }

    public LinkGenerator setReferrerName(String str) {
        this.unregisterClient = str;
        return this;
    }

    public LinkGenerator setReferrerImageURL(String str) {
        this.AFLogger = str;
        return this;
    }

    public LinkGenerator setBaseURL(String str, String str2, String str3) {
        if (str == null || str.length() <= 0) {
            this.AFInAppEventParameterName = String.format("https://%s/%s", String.format("%sapp.%s", AppsFlyerLib.getInstance().getHostPrefix(), AFb1vSDK.valueOf().getHostName()), str3);
        } else {
            if (str2 == null || str2.length() < 5) {
                str2 = "go.onelink.me";
            }
            this.AFInAppEventParameterName = String.format("https://%s/%s", str2, str);
        }
        return this;
    }

    private Map<String, String> values() {
        HashMap map = new HashMap();
        map.put("pid", this.AFKeystoreWrapper);
        String str = this.f421e;
        if (str != null) {
            map.put("af_referrer_uid", str);
        }
        String str2 = this.values;
        if (str2 != null) {
            map.put(AFInAppEventParameterName.AF_CHANNEL, str2);
        }
        String str3 = this.registerClient;
        if (str3 != null) {
            map.put("af_referrer_customer_id", str3);
        }
        String str4 = this.valueOf;
        if (str4 != null) {
            map.put("c", str4);
        }
        String str5 = this.unregisterClient;
        if (str5 != null) {
            map.put("af_referrer_name", str5);
        }
        String str6 = this.AFLogger;
        if (str6 != null) {
            map.put("af_referrer_image_url", str6);
        }
        if (this.f422i != null) {
            StringBuilder sb = new StringBuilder();
            sb.append(this.f422i);
            String str7 = this.f420d;
            if (str7 != null) {
                this.f420d = str7.replaceFirst("^[/]", "");
                sb.append(this.f422i.endsWith("/") ? "" : "/");
                sb.append(this.f420d);
            }
            map.put("af_dp", sb.toString());
        }
        for (Map.Entry<String, String> entry : this.force.entrySet()) {
            map.put(entry.getKey(), entry.getValue());
        }
        return AFb1aSDK.values(map);
    }

    public String generateLink() {
        StringBuilder sb = new StringBuilder();
        String str = this.AFInAppEventParameterName;
        if (str != null && str.startsWith(ProxyConfig.MATCH_HTTP)) {
            sb.append(this.AFInAppEventParameterName);
        } else {
            sb.append(String.format(AFj1zSDK.AFInAppEventParameterName, AppsFlyerLib.getInstance().getHostPrefix(), AFb1vSDK.valueOf().getHostName()));
        }
        if (this.AFInAppEventType != null) {
            sb.append('/');
            sb.append(this.AFInAppEventType);
        }
        Map<String, String> mapValues = values();
        StringBuilder sb2 = new StringBuilder();
        for (Map.Entry<String, String> entry : mapValues.entrySet()) {
            if (sb2.length() == 0) {
                sb2.append('?');
            } else {
                sb2.append('&');
            }
            sb2.append(entry.getKey());
            sb2.append('=');
            sb2.append(entry.getValue());
        }
        sb.append(sb2.toString());
        return sb.toString();
    }

    public void generateLink(Context context, ResponseListener responseListener) {
        String string = AppsFlyerProperties.getInstance().getString(AppsFlyerProperties.ONELINK_ID);
        String str = this.f423w;
        Map<String, String> mapValues = values();
        if (AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.AF_WAITFOR_CUSTOMERID, false)) {
            AFLogger.afInfoLog("CustomerUserId not set, generate User Invite Link is disabled", true);
            return;
        }
        AFb1vSDK.valueOf().AFInAppEventType(context);
        AFd1nSDK aFd1nSDKAFInAppEventType = AFb1vSDK.valueOf().AFInAppEventType();
        AFf1uSDK aFf1uSDK = new AFf1uSDK(aFd1nSDKAFInAppEventType, UUID.randomUUID(), string, mapValues, str, responseListener, this);
        AFe1dSDK aFe1dSDKMo787w = aFd1nSDKAFInAppEventType.mo787w();
        aFe1dSDKMo787w.values.execute(aFe1dSDKMo787w.new RunnableC08534(aFf1uSDK));
    }

    @Deprecated
    public void generateLink(Context context, final CreateOneLinkHttpTask.ResponseListener responseListener) {
        generateLink(context, new ResponseListener() {
            @Override
            public final void onResponse(String str) {
                responseListener.onResponse(str);
            }

            @Override
            public final void onResponseError(String str) {
                responseListener.onResponseError(str);
            }
        });
    }
}

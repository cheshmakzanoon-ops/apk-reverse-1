package cn.thinkingdata.android;

import cn.thinkingdata.android.utils.EnumC0761l;
import cn.thinkingdata.android.utils.InterfaceC0754e;
import java.util.Map;
import org.json.JSONException;
import org.json.JSONObject;

class C0718a {

    String f144a;

    private final InterfaceC0754e f145b;

    final EnumC0761l f146c;

    private String f147d;

    private String f148e;

    private final JSONObject f149f;

    private Map<String, String> f150g;

    boolean f151h = true;

    final String f152i;

    C0718a(ThinkingAnalyticsSDK thinkingAnalyticsSDK, EnumC0761l enumC0761l, JSONObject jSONObject, InterfaceC0754e interfaceC0754e) {
        this.f146c = enumC0761l;
        this.f149f = jSONObject;
        this.f145b = interfaceC0754e;
        this.f152i = thinkingAnalyticsSDK.getToken();
        this.f147d = thinkingAnalyticsSDK.getDistinctId();
        this.f148e = thinkingAnalyticsSDK.getLoginId();
    }

    public JSONObject m438a() {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("#type", this.f146c.m715a());
            jSONObject.put("#time", this.f145b.mo699b());
            jSONObject.put("#distinct_id", this.f147d);
            String str = this.f148e;
            if (str != null) {
                jSONObject.put("#account_id", str);
            }
            Map<String, String> map = this.f150g;
            if (map != null) {
                for (Map.Entry<String, String> entry : map.entrySet()) {
                    jSONObject.put(entry.getKey(), entry.getValue());
                }
            }
            if (this.f146c.m716b()) {
                jSONObject.put("#event_name", this.f144a);
                Double dMo698a = this.f145b.mo698a();
                if (dMo698a != null && !TDPresetProperties.disableList.contains("#zone_offset")) {
                    this.f149f.put("#zone_offset", dMo698a);
                }
            }
            jSONObject.put("properties", this.f149f);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jSONObject;
    }

    void m439a(Map<String, String> map) {
        this.f150g = map;
    }

    void m440b() {
        this.f151h = false;
    }
}

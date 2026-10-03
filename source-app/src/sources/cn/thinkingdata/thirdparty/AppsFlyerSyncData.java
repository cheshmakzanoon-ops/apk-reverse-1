package cn.thinkingdata.thirdparty;

import cn.thinkingdata.android.utils.TDLog;
import java.util.HashMap;
import java.util.Map;

public class AppsFlyerSyncData extends AbstractSyncThirdData {
    private final Map<String, Object> mCustomMap;

    public AppsFlyerSyncData(String str, String str2, Map<String, Object> map) {
        super(str, str2);
        this.mCustomMap = map;
    }

    @Override
    public void syncThirdPartyData() {
        TDLog.m679d("ThinkingAnalytics.SyncData", "开始同步Appsflyer数据");
        HashMap map = new HashMap();
        map.put(TAThirdConstants.TA_DISTINCT_ID, this.distinctId == null ? "" : this.distinctId);
        map.put(TAThirdConstants.TA_ACCOUNT_ID, this.accountId != null ? this.accountId : "");
        Map<String, Object> map2 = this.mCustomMap;
        if (map2 != null) {
            for (Map.Entry<String, Object> entry : map2.entrySet()) {
                map.put(entry.getKey(), entry.getValue());
            }
        }
        try {
            Class<?> cls = Class.forName("com.appsflyer.AppsFlyerLib");
            cls.getMethod("setAdditionalData", Map.class).invoke(cls.getMethod("getInstance", null).invoke(null, null), map);
            TDLog.m679d("ThinkingAnalytics.SyncData", "AppsFlyer数据同步成功");
        } catch (NoSuchMethodException e) {
            TDLog.m680e("ThinkingAnalytics.SyncData", "AppsFlyer数据同步异常:" + e.getMessage());
            syncThirdPartyData5(map);
        } catch (Exception e2) {
            TDLog.m680e("ThinkingAnalytics.SyncData", "AppsFlyer数据同步异常:" + e2.getMessage());
        }
    }

    private void syncThirdPartyData5(Map<String, Object> map) {
        TDLog.m679d("ThinkingAnalytics.SyncData", "重新开始同步Appsflyer数据");
        try {
            Class<?> cls = Class.forName("com.appsflyer.AppsFlyerLib");
            cls.getMethod("setAdditionalData", HashMap.class).invoke(cls.getMethod("getInstance", null).invoke(null, null), (HashMap) map);
            TDLog.m679d("ThinkingAnalytics.SyncData", "同步Appsflyer数据成功");
        } catch (Exception e) {
            TDLog.m680e("ThinkingAnalytics.SyncData", "AppsFlyer数据同步异常:" + e.getMessage());
        }
    }
}

package cn.thinkingdata.thirdparty;

import cn.thinkingdata.android.ThinkingAnalyticsSDK;
import java.util.Map;

public class TAThirdPartyManager {
    public static void enableThirdPartySharing(int i, ThinkingAnalyticsSDK thinkingAnalyticsSDK, String str) {
        if ((i & 1) > 0) {
            enableThirdPartySharing(1, thinkingAnalyticsSDK, str, null);
        }
        if ((i & 2) > 0) {
            enableThirdPartySharing(2, thinkingAnalyticsSDK, str, null);
        }
        if ((i & 4) > 0) {
            enableThirdPartySharing(4, thinkingAnalyticsSDK, str, null);
        }
        if ((i & 8) > 0) {
            enableThirdPartySharing(8, thinkingAnalyticsSDK, str, null);
        }
        if ((i & 16) > 0) {
            enableThirdPartySharing(16, thinkingAnalyticsSDK, str, null);
        }
        if ((i & 32) > 0) {
            enableThirdPartySharing(32, thinkingAnalyticsSDK, str, null);
        }
        if ((i & 64) > 0) {
            enableThirdPartySharing(64, thinkingAnalyticsSDK, str, null);
        }
    }

    public static void enableThirdPartySharing(int i, ThinkingAnalyticsSDK thinkingAnalyticsSDK, String str, Map<String, Object> map) {
        ISyncThirdPartyData iSyncThirdPartyDataCreate = TAThirdPartyFactory.create(i, thinkingAnalyticsSDK, str, map);
        if (iSyncThirdPartyDataCreate != null) {
            iSyncThirdPartyDataCreate.syncThirdPartyData();
        }
    }
}

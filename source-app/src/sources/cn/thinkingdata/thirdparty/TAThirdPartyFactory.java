package cn.thinkingdata.thirdparty;

import cn.thinkingdata.android.ThinkingAnalyticsSDK;
import java.util.Map;

public class TAThirdPartyFactory {
    public static ISyncThirdPartyData create(int i, ThinkingAnalyticsSDK thinkingAnalyticsSDK, String str, Map<String, Object> map) {
        if (i == 1) {
            return new AppsFlyerSyncData(thinkingAnalyticsSDK.getDistinctId(), str, map);
        }
        if (i == 2) {
            return new IronSourceSyncData(thinkingAnalyticsSDK);
        }
        if (i == 4) {
            return new AdjustSyncData(thinkingAnalyticsSDK.getDistinctId(), str);
        }
        if (i == 8) {
            return new BranchSyncData(thinkingAnalyticsSDK.getDistinctId(), str);
        }
        if (i == 16) {
            return new TopOnSyncData(thinkingAnalyticsSDK.getDistinctId(), map);
        }
        if (i == 32) {
            return new TrackingSyncData(thinkingAnalyticsSDK.getDistinctId());
        }
        if (i != 64) {
            return null;
        }
        return new TradPlusSyncData(thinkingAnalyticsSDK.getDistinctId());
    }
}

package cn.thinkingdata.thirdparty;

import cn.thinkingdata.android.utils.TDLog;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

public class TradPlusSyncData extends AbstractSyncThirdData {
    public TradPlusSyncData(String str) {
        super(str);
    }

    @Override
    public void syncThirdPartyData() {
        TDLog.m679d("ThinkingAnalytics.SyncData", "开始同步TradPlus数据");
        try {
            Method method = Class.forName("com.tradplus.ads.mobileads.util.SegmentUtils").getMethod("initCustomMap", Map.class);
            HashMap map = new HashMap();
            map.put((String) Class.forName("com.tradplus.ads.mobileads.util.AppKeyManager").getField("CUSTOM_USERID").get(null), this.distinctId == null ? "" : this.distinctId);
            method.invoke(null, map);
            TDLog.m680e("ThinkingAnalytics.SyncData", "TradPlus数据同步成功:");
        } catch (Exception e) {
            TDLog.m680e("ThinkingAnalytics.SyncData", "TradPlus数据同步异常:" + e.getMessage());
        }
    }
}

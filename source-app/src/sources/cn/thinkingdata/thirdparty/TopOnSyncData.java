package cn.thinkingdata.thirdparty;

import cn.thinkingdata.android.utils.TDLog;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

public class TopOnSyncData extends AbstractSyncThirdData {
    private final Map<String, Object> mCustomMap;

    public TopOnSyncData(String str, Map<String, Object> map) {
        super(str);
        this.mCustomMap = map;
    }

    @Override
    public void syncThirdPartyData() {
        TDLog.m679d("ThinkingAnalytics.SyncData", "开始同步TopOn数据");
        try {
            Method method = Class.forName("com.anythink.core.api.ATSDK").getMethod("initCustomMap", Map.class);
            HashMap map = new HashMap();
            map.put((String) Class.forName("com.anythink.core.api.ATCustomRuleKeys").getField("USER_ID").get(null), this.distinctId == null ? "" : this.distinctId);
            Map<String, Object> map2 = this.mCustomMap;
            if (map2 != null) {
                for (Map.Entry<String, Object> entry : map2.entrySet()) {
                    map.put(entry.getKey(), entry.getValue());
                }
            }
            method.invoke(null, map);
            TDLog.m680e("ThinkingAnalytics.SyncData", "TopOn数据同步成功");
        } catch (Exception e) {
            TDLog.m680e("ThinkingAnalytics.SyncData", "TopOn数据同步异常:" + e.getMessage());
        }
    }
}

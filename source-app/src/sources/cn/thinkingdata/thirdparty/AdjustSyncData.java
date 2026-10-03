package cn.thinkingdata.thirdparty;

import cn.thinkingdata.android.utils.TDLog;
import java.lang.reflect.Method;

public class AdjustSyncData extends AbstractSyncThirdData {
    public AdjustSyncData(String str, String str2) {
        super(str, str2);
    }

    @Override
    public void syncThirdPartyData() {
        TDLog.m679d("ThinkingAnalytics.SyncData", "开始同步Adjust数据");
        try {
            Method method = Class.forName("com.adjust.sdk.Adjust").getMethod("addSessionCallbackParameter", String.class, String.class);
            String str = "";
            method.invoke(null, TAThirdConstants.TA_DISTINCT_ID, this.distinctId == null ? "" : this.distinctId);
            if (this.accountId != null) {
                str = this.accountId;
            }
            method.invoke(null, TAThirdConstants.TA_ACCOUNT_ID, str);
            TDLog.m679d("ThinkingAnalytics.SyncData", "Adjust数据同步成功");
        } catch (Exception e) {
            TDLog.m680e("ThinkingAnalytics.SyncData", "Adjust数据同步异常:" + e.getMessage());
        }
    }
}

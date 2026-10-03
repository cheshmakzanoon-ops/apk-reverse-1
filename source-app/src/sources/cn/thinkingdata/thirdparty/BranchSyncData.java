package cn.thinkingdata.thirdparty;

import cn.thinkingdata.android.utils.TDLog;
import java.lang.reflect.Method;

public class BranchSyncData extends AbstractSyncThirdData {
    public BranchSyncData(String str, String str2) {
        super(str, str2);
    }

    @Override
    public void syncThirdPartyData() {
        TDLog.m679d("ThinkingAnalytics.SyncData", "开始同步Branch数据");
        try {
            Class<?> cls = Class.forName("io.branch.referral.Branch");
            Object objInvoke = cls.getMethod("getInstance", null).invoke(null, null);
            Method method = cls.getMethod("setRequestMetadata", String.class, String.class);
            String str = "";
            method.invoke(objInvoke, TAThirdConstants.TA_DISTINCT_ID, this.distinctId == null ? "" : this.distinctId);
            if (this.accountId != null) {
                str = this.accountId;
            }
            method.invoke(objInvoke, TAThirdConstants.TA_ACCOUNT_ID, str);
            TDLog.m680e("ThinkingAnalytics.SyncData", "Branch数据同步成功");
        } catch (Exception e) {
            TDLog.m680e("ThinkingAnalytics.SyncData", "Branch数据同步异常:" + e.getMessage());
        }
    }
}

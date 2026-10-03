package cn.thinkingdata.thirdparty;

import cn.thinkingdata.android.utils.TDLog;

public class TrackingSyncData extends AbstractSyncThirdData {
    public TrackingSyncData(String str) {
        super(str);
    }

    @Override
    public void syncThirdPartyData() {
        TDLog.m679d("ThinkingAnalytics.SyncData", "开始同步热云数据");
        try {
            Class.forName("com.reyun.tracking.sdk.Tracking").getMethod("setRegisterWithAccountID", String.class).invoke(null, this.distinctId == null ? "" : this.distinctId);
            TDLog.m680e("ThinkingAnalytics.SyncData", "Tracking数据同步成功");
        } catch (Exception e) {
            TDLog.m680e("ThinkingAnalytics.SyncData", "Tracking数据同步异常:" + e.getMessage());
        }
    }
}

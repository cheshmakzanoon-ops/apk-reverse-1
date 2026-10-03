package cn.thinkingdata.thirdparty;

public abstract class AbstractSyncThirdData implements ISyncThirdPartyData {
    protected static final String TAG = "ThinkingAnalytics.SyncData";
    protected String accountId;
    protected String distinctId;

    public AbstractSyncThirdData() {
    }

    public AbstractSyncThirdData(String str) {
        this.distinctId = str;
    }

    public AbstractSyncThirdData(String str, String str2) {
        this.distinctId = str;
        this.accountId = str2;
    }
}

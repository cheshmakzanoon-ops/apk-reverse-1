package cn.thinkingdata.android;

import android.text.TextUtils;
import cn.thinkingdata.android.utils.EnumC0761l;
import cn.thinkingdata.android.utils.TDLog;
import org.json.JSONObject;

public class TDFirstEvent extends AbstractC0737n {
    private static final String TAG = "ThinkingAnalytics.TDUniqueEvent";
    private String mExtraValue;

    public TDFirstEvent(String str, JSONObject jSONObject) {
        super(str, jSONObject);
    }

    @Override
    EnumC0761l getDataType() {
        return EnumC0761l.TRACK;
    }

    @Override
    String getExtraField() {
        return "#first_check_id";
    }

    @Override
    String getExtraValue() {
        return this.mExtraValue;
    }

    public void setFirstCheckId(String str) {
        if (TextUtils.isEmpty(str)) {
            TDLog.m687w(TAG, "Invalid firstCheckId. Use device Id");
        } else {
            this.mExtraValue = str;
        }
    }
}

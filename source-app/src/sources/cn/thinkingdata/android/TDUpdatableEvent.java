package cn.thinkingdata.android;

import cn.thinkingdata.android.utils.EnumC0761l;
import org.json.JSONObject;

public class TDUpdatableEvent extends AbstractC0737n {
    private final String mEventId;

    public TDUpdatableEvent(String str, JSONObject jSONObject, String str2) {
        super(str, jSONObject);
        this.mEventId = str2;
    }

    @Override
    EnumC0761l getDataType() {
        return EnumC0761l.TRACK_UPDATE;
    }

    @Override
    String getExtraField() {
        return "#event_id";
    }

    @Override
    String getExtraValue() {
        return this.mEventId;
    }
}

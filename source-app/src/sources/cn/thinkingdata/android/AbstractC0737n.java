package cn.thinkingdata.android;

import cn.thinkingdata.android.utils.EnumC0761l;
import java.util.Date;
import java.util.TimeZone;
import org.json.JSONObject;

public abstract class AbstractC0737n {
    private final String mEventName;
    private Date mEventTime;
    private final JSONObject mProperties;
    private TimeZone mTimeZone;

    AbstractC0737n(String str, JSONObject jSONObject) {
        this.mEventName = str;
        this.mProperties = jSONObject;
    }

    abstract EnumC0761l getDataType();

    String getEventName() {
        return this.mEventName;
    }

    Date getEventTime() {
        return this.mEventTime;
    }

    abstract String getExtraField();

    abstract String getExtraValue();

    JSONObject getProperties() {
        return this.mProperties;
    }

    TimeZone getTimeZone() {
        return this.mTimeZone;
    }

    public void setEventTime(Date date) {
        this.mEventTime = date;
    }

    public void setEventTime(Date date, TimeZone timeZone) {
        this.mEventTime = date;
        this.mTimeZone = timeZone;
    }
}

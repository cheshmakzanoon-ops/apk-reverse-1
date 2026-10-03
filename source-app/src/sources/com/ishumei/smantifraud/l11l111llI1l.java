package com.ishumei.smantifraud;

import org.json.JSONObject;

public class l11l111llI1l extends l1l11I1l {
    public static final String l111l11IlIlIl = "deviceId";
    public static final int l11l111l11Il = -1;
    public static final String l11l111l1I1l = "deviceId";
    public static final String l11l111l1Il = "oldDeviceId";
    public static final int l11l111l1lll = -1;
    public static final String l11l111ll11l = "sid";
    public static final String l11l111ll1Il = "c";
    public static final String l11l111lll = "t";
    public final String l11l1111I1l;
    public final String l11l1111I1ll;
    public final String l11l1111Il;
    public final String l11l1111Il1l;
    public final int l11l1111Ill;
    public final int l11l11IlIIll;

    public l11l111llI1l(int i, String str, String str2, JSONObject jSONObject) {
        this.l1111l111111Il = i;
        this.l111l11111lIl = str;
        this.l11l1111I1l = str2;
        int iOptInt = -1;
        if (jSONObject == null) {
            this.l11l1111I1ll = null;
            this.l11l1111Il = null;
            this.l11l1111Il1l = null;
            this.l11l1111Ill = -1;
        } else {
            this.l11l1111I1ll = jSONObject.optString("deviceId");
            this.l11l1111Il = jSONObject.optString(l11l111l1Il);
            this.l11l1111Il1l = jSONObject.optString("sid");
            this.l11l1111Ill = jSONObject.optInt("c", -1);
            iOptInt = jSONObject.optInt("t", -1);
        }
        this.l11l11IlIIll = iOptInt;
    }

    public String l111l11111Il() {
        return this.l11l1111I1ll;
    }
}

package com.ishumei.smantifraud;

import org.json.JSONObject;

public class l111l11IlIlIl extends l1l11I11lll<l11l111l1I1l> {
    public l111l11IlIlIl(String str, String str2, l1l11lIl.l111l11111lIl<l11l111l1I1l> l111l11111lil, l1l11lIl.l1111l111111Il l1111l111111il) {
        super(1, str, str2, null, l111l11111lil, l1111l111111il);
    }

    @Override
    public l1l11lIl<l11l111l1I1l> l1111l111111Il(l1l11ll1Il l1l11ll1il) {
        try {
            JSONObject jSONObject = new JSONObject(new String(l1l11ll1il.l111l11111lIl));
            JSONObject jSONObjectOptJSONObject = jSONObject.optJSONObject(l1l11I1l.l11l1111I11l);
            if (jSONObjectOptJSONObject != null && jSONObjectOptJSONObject.has("data")) {
                return new l1l11lIl<>(new l11l111l1I1l(jSONObject.optInt("code", -1), jSONObject.optString(l1l11I1l.l11l1111lIIl, ""), jSONObjectOptJSONObject));
            }
        } catch (Throwable unused) {
        }
        return new l1l11lIl<>(new l1l11I11ll("no conf data", -4));
    }
}

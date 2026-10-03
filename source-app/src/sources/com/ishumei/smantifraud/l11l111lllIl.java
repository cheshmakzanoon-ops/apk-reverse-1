package com.ishumei.smantifraud;

import android.text.TextUtils;
import org.json.JSONObject;

public class l11l111lllIl extends l1l11I11lll<l11l111llI1l> {
    public l11l111lllIl(String str, String str2, l1l11lIl.l111l11111lIl<l11l111llI1l> l111l11111lil, l1l11lIl.l1111l111111Il l1111l111111il) {
        super(1, str, str2, null, l111l11111lil, l1111l111111il);
    }

    @Override
    public l1l11lIl<l11l111llI1l> l1111l111111Il(l1l11ll1Il l1l11ll1il) {
        try {
            JSONObject jSONObject = new JSONObject(new String(l1l11ll1il.l111l11111lIl));
            int iOptInt = jSONObject.optInt("code", -1);
            l11l111llI1l l11l111lli1l = new l11l111llI1l(iOptInt, jSONObject.optString(l1l11I1l.l11l1111lIIl), jSONObject.optString("deviceId"), jSONObject.optJSONObject(l1l11I1l.l11l1111I11l));
            if (!TextUtils.isEmpty(l11l111lli1l.l11l1111I1ll)) {
                return new l1l11lIl<>(l11l111lli1l);
            }
            if (iOptInt == 1902) {
                this.l11l111ll11l = null;
            }
            return new l1l11lIl<>(new l1l11I11ll(iOptInt));
        } catch (Throwable unused) {
            return new l1l11lIl<>(new l1l11I11ll(-3));
        }
    }
}

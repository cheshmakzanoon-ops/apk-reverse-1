package com.ishumei.smantifraud;

import android.text.TextUtils;
import com.ishumei.smantifraud.dfp.SMSDK;
import java.util.Collection;
import java.util.Set;
import org.json.JSONArray;
import org.json.JSONObject;

public class l1l1l111Il {
    public static String l1111l111111Il(Set<JSONObject> set, JSONObject jSONObject, boolean z) {
        String str;
        try {
            JSONObject jSONObject2 = new JSONObject();
            jSONObject2.put(l111l1111lI1l.l1111l111111Il, SmAntiFraud.option.getOrganization());
            String strL111l11111Il = l111l11I1IIIl.l111l1111l1Il().l111l11111Il();
            if (TextUtils.isEmpty(strL111l11111Il)) {
                strL111l11111Il = "";
                str = strL111l11111Il;
            } else if (strL111l11111Il.startsWith("B")) {
                str = "";
            } else {
                str = strL111l11111Il;
                strL111l11111Il = "";
            }
            if (TextUtils.isEmpty(strL111l11111Il)) {
                strL111l11111Il = l111l11I1IIIl.l111l1111l1Il().l111l1111lIl();
                if (TextUtils.isEmpty(strL111l11111Il)) {
                    strL111l11111Il = l111l11I1IIIl.l111l1111l1Il().l111l1111lI1l();
                }
            }
            if (!TextUtils.isEmpty(strL111l11111Il)) {
                jSONObject2.put(l111l1111lI1l.l111l11111lIl, strL111l11111Il);
            } else if (z) {
                jSONObject2.put(l111l1111lI1l.l111l11111lIl, str);
            } else {
                jSONObject2.put(l111l1111lI1l.l111l11111lIl, "");
            }
            JSONArray jSONArray = new JSONArray((Collection) set);
            if (jSONObject != null) {
                jSONArray.put(jSONObject);
            }
            jSONObject2.put(l111l1111lI1l.l111l1111l1Il, SmAntiFraud.option.getAppId());
            jSONObject2.put(l111l1111lI1l.l111l1111llIl, l111l11111lIl.l111l11111lIl());
            jSONObject2.put(l111l1111lI1l.l11l1111I1ll, l11l11l111Il.l111l11111lIl);
            jSONObject2.put("wevent", jSONArray);
            return SMSDK.m375v3(l11l11l111Il.l1111l111111Il, jSONObject2.toString(), SmAntiFraud.option.getPublicKey(), SmAntiFraud.option.getOrganization(), SmAntiFraud.option.getAppId());
        } catch (Throwable th) {
            return l111l111I1l.l111l11111lIl.l1111l111111Il.l1111l111111Il(th);
        }
    }
}

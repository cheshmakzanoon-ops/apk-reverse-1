package com.ishumei.smantifraud;

import android.os.Build;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Set;
import org.json.JSONObject;

public class l111l111I1l {
    public final SmAntiFraud.SmOption l1111l111111Il;

    public static class l111l11111lIl {
        public static final l111l111I1l l1111l111111Il = new l111l111I1l();
    }

    public l111l111I1l() {
        this.l1111l111111Il = SmAntiFraud.option;
    }

    public static l111l111I1l l1111l111111Il() {
        return l111l11111lIl.l1111l111111Il;
    }

    public String l1111l111111Il(Throwable th) {
        try {
            l11l111I11l l11l111i11lL111l11111lIl = l111l11111lIl();
            l11l111i11lL111l11111lIl.l111l1111l1Il(l111l11111lIl(th));
            String strL1111l111111Il = l1l1l11Ill.l1111l111111Il(l1l1l11Ill.l1111l111111Il(l11l111i11lL111l11111lIl, (Set<String>) null).toString().getBytes());
            JSONObject jSONObject = new JSONObject();
            jSONObject.put(l111l1111lI1l.l1111l111111Il, l11l111i11lL111l11111lIl.l111l1111llIl());
            jSONObject.put(l111l1111lI1l.l111l11111I1l, l11l11lI1lll.l111l1111l1Il);
            SmAntiFraud.SmOption smOption = this.l1111l111111Il;
            if (smOption != null) {
                jSONObject.put(l111l1111lI1l.l111l1111l1Il, smOption.getAppId());
            }
            jSONObject.put(l111l1111lI1l.l111l1111lI1l, 1);
            jSONObject.put("data", strL1111l111111Il);
            jSONObject.put(l111l1111lI1l.l11l1111I11l, "");
            jSONObject.put(l111l1111lI1l.l11l1111I1l, "");
            return jSONObject.toString();
        } catch (Throwable th2) {
            return th2.toString();
        }
    }

    public final l11l111I11l l111l11111lIl() {
        l11l111I11l l11l111i11l = new l11l111I11l();
        l11l111i11l.l1111l111111Il = "exception";
        l11l111i11l.l111l11111I1l = l11l11lI1lll.l111l1111l1Il;
        l11l111i11l.l111l11111Il = l11l11lI1lll.l111l11111I1l;
        l11l111i11l.l111l1111lI1l = com.ishumei.smantifraud.l111l11111lIl.l111l11111Il();
        l11l111i11l.l111l1111lIl = com.ishumei.smantifraud.l111l11111lIl.l111l11111lIl();
        l11l111i11l.l111l1111l1Il = Build.VERSION.RELEASE;
        l11l111i11l.l11l1111lIIl = Build.MODEL;
        SmAntiFraud.SmOption smOption = this.l1111l111111Il;
        if (smOption != null) {
            l11l111i11l.l11l1111I11l = smOption.getOrganization();
            l11l111i11l.l111l1111llIl = this.l1111l111111Il.getAppId();
        }
        l11l111i11l.l11l1111I1l = l111l11I1IIIl.l111l1111l1Il().l1111l111111Il();
        l11l111i11l.l111l11111lIl = l111l11I1IIIl.l111l1111l1Il().l111l1111llIl();
        return l11l111i11l;
    }

    public final String l111l11111lIl(Throwable th) {
        if (th == null) {
            return "";
        }
        try {
            StringWriter stringWriter = new StringWriter();
            PrintWriter printWriter = new PrintWriter(stringWriter);
            do {
                th.printStackTrace(printWriter);
                th = th.getCause();
            } while (th != null);
            printWriter.close();
            String string = stringWriter.toString();
            return string.length() > 4096 ? string.substring(0, l111l11l11Ill.l111l11111lIl) : string;
        } catch (Throwable unused) {
            return "";
        }
    }
}

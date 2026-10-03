package com.ishumei.smantifraud;

import android.os.Build;
import android.os.Debug;
import android.os.StatFs;
import org.json.JSONObject;

public class l11l111I111l extends AbsDetector {
    @Override
    public String getEventId() {
        return l111l111lIlll.l11l111ll1Il;
    }

    public JSONObject l1111l111111Il() {
        l111l111lIlll l111l111lilll = new l111l111lIlll();
        l111l111lilll.l111l11IlIlIl = System.currentTimeMillis();
        l111l111lilll.l11l111l1I1l = getAndIncrementSerial();
        l111l111lilll.l111l11111lIl = l1111l111111Il.l1111l111111Il();
        l111l111lilll.l111l11111I1l = "" + l1111l111111Il.l111l11111I1l();
        StatFs statFsL111l1111llIl = l11l111lIll.l111l1111llIl();
        if (statFsL111l1111llIl != null) {
            l111l111lilll.l111l11111Il = Long.valueOf(statFsL111l1111llIl.getAvailableBytes());
            l111l111lilll.l11l111l1lll = Long.valueOf(statFsL111l1111llIl.getTotalBytes());
        }
        l111l111lilll.l111l1111l1Il = Build.getRadioVersion();
        l111l111lilll.l111l1111llIl = l11l1111Il.l1111l111111Il();
        l111l111lilll.l111l1111lI1l = l1111l111111Il.l111l1111lI1l();
        l111l111lilll.l111l1111lIl = Long.valueOf(l1l11I111ll.l111l11111I1l());
        l111l111lilll.l11l1111lIIl = Integer.valueOf(l111l111llIl.l111l11111I1l());
        l111l111lilll.l11l1111I11l = Integer.valueOf(Debug.isDebuggerConnected() ? 1 : 0);
        l111l111lilll.l11l1111I1l = l11l11l111Il.l1111l111111Il.getFilesDir().toString();
        l111l111lilll.l11l1111Il1l = Long.valueOf(l111l111llIl.l111l11111Il());
        l111l111lilll.l11l1111I1ll = l1111l111111Il.l11l1111I1ll();
        l111l111lilll.l11l1111Il = Build.VERSION.RELEASE;
        l111l111lilll.l11l1111Ill = l1l11l1Illl.l111l11111I1l();
        l111l111lilll.l11l11IlIIll = l11l111lIll.l111l1111l1Il();
        l111l111lilll.l1111l111111Il = l111l11I1IIIl.l111l1111l1Il().l111l1111llIl();
        l111l111lilll.l11l111l11Il = l11l11lI1lll.l111l11111I1l;
        return l111l111lilll.l1111l111111Il();
    }
}

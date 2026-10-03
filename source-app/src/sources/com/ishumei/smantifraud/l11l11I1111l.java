package com.ishumei.smantifraud;

import android.content.Context;
import android.hardware.display.DisplayManager;
import android.view.Display;
import com.google.firebase.messaging.Constants;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class l11l11I1111l {
    public static final String l111l1111l1Il = "type";
    public static final String l111l1111lI1l = "flg";
    public static final String l111l1111lIl = "opn";
    public static final String l111l1111llIl = "state";
    public int l111l11111I1l;
    public DisplayManager l111l11111Il;
    public final List<Map<String, Object>> l1111l111111Il = new ArrayList();
    public int l111l11111lIl = 0;

    public int l1111l111111Il() {
        return this.l111l11111I1l;
    }

    public final void l1111l111111Il(Display[] displayArr) {
        int iIntValue;
        this.l1111l111111Il.clear();
        this.l111l11111lIl = 0;
        if (displayArr == null || displayArr.length == 1) {
            return;
        }
        for (Display display : displayArr) {
            try {
                HashMap map = new HashMap();
                int state = display.getState();
                map.put(l111l1111llIl, Integer.valueOf(state));
                map.put(l111l1111lI1l, Integer.valueOf(display.getFlags()));
                try {
                    Method declaredMethod = Display.class.getDeclaredMethod("getType", null);
                    declaredMethod.setAccessible(true);
                    Integer num = (Integer) declaredMethod.invoke(display, null);
                    iIntValue = num.intValue();
                    try {
                        map.put(l111l1111l1Il, num);
                        Field declaredField = Display.class.getDeclaredField("mOwnerPackageName");
                        declaredField.setAccessible(true);
                        map.put(l111l1111lIl, declaredField.get(display));
                    } catch (Exception unused) {
                    }
                } catch (Exception unused2) {
                    iIntValue = -1;
                }
                this.l1111l111111Il.add(map);
                if (iIntValue == 5 && state == 2) {
                    this.l111l11111lIl++;
                }
            } catch (Throwable unused3) {
            }
        }
    }

    public boolean l1111l111111Il(Context context, boolean z) {
        try {
            if (this.l111l11111Il == null) {
                this.l111l11111Il = (DisplayManager) context.getSystemService(Constants.ScionAnalytics.MessageType.DISPLAY_NOTIFICATION);
            }
            DisplayManager displayManager = this.l111l11111Il;
            if (displayManager == null) {
                return false;
            }
            Display[] displays = displayManager.getDisplays();
            l1111l111111Il(displays);
            if (displays != null && displays.length > 1) {
                if (z) {
                    this.l111l11111I1l++;
                } else if (this.l111l11111I1l == 0) {
                    this.l111l11111I1l = 1;
                }
                return true;
            }
            return false;
        } catch (Throwable unused) {
        }
    }

    public int l111l11111I1l() {
        return this.l111l11111lIl;
    }

    public List<Map<String, Object>> l111l11111lIl() {
        return new ArrayList(this.l1111l111111Il);
    }
}

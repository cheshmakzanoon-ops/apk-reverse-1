package com.ishumei.smantifraud;

import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import java.lang.reflect.Method;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import org.json.JSONObject;

public class l1l1l11Il {
    public static l1l1l11Il l111l111I1l = null;
    public static final int l111l111lIlll = 3;
    public static final int l111l111llIl = 2;
    public static final String l111l11IlIlIl = "wevent";
    public static final int l11l111I111l = 10;
    public static final int l11l111I11l = 50;
    public static final String l11l111l1I1l = "screenrecord";
    public static final String l11l111l1Il = "screenshot";
    public static final String l11l111l1lll = "eventId";
    public static final int l11l111lI1l = 0;
    public static final int l11l111lIll = 2;
    public static final String l11l111ll11l = "gpsevent";
    public static final String l11l111ll1Il = "textinput";
    public static final int l11l111llI1l = 1;
    public static final String l11l111lll = "mem";
    public static final int l11l111lllIl = 0;
    public static final int l11l11l1lIl = 1;
    public Handler l1111l111111Il;
    public final Handler l111l11111I1l;
    public final HandlerThread l111l11111Il;
    public HandlerThread l111l11111lIl;
    public final l11l11l1I1l<JSONObject> l111l1111l1Il;
    public final l11l11l1I1l<JSONObject> l111l1111lI1l;
    public final l11l11l1I1l<JSONObject> l111l1111lIl;
    public final l11l11l1I1l<JSONObject> l111l1111llIl;
    public final l11l11l1I1l<JSONObject> l11l1111I11l;
    public final List<AbsDetector> l11l1111I1l;
    public final int l11l1111I1ll;
    public final int l11l1111Il;
    public int l11l1111Il1l;
    public final l11l111I111l l11l1111Ill;
    public final l11l11l1I1l<JSONObject> l11l1111lIIl;
    public final VDataListener l11l11IlIIll = new l111l11111lIl();
    public final Runnable l11l111l11Il = new l111l11111I1l();

    public class l1111l111111Il extends Handler {
        public l1111l111111Il(Looper looper) {
            super(looper);
        }

        @Override
        public void handleMessage(Message message) {
            try {
                int i = message.what;
                boolean z = true;
                if (i == 0) {
                    l1l1l11Il l1l1l11il = l1l1l11Il.this;
                    JSONObject jSONObject = (JSONObject) message.obj;
                    if (message.arg1 != 1) {
                        z = false;
                    }
                    l1l1l11il.l1111l111111Il(jSONObject, z);
                } else if (i == 1) {
                    l1l1l11Il.this.l1111l111111Il((Set<JSONObject>) message.obj);
                } else if (i == 2) {
                    l1l1l11Il.this.l111l11111lIl((Set<JSONObject>) message.obj);
                } else if (i == 3) {
                    l1l1l11Il l1l1l11il2 = l1l1l11Il.this;
                    l1l1l11il2.l111l11111Il(l1l1l11il2.l111l11111lIl());
                }
            } catch (Throwable unused) {
            }
        }
    }

    public class l111l11111I1l implements Runnable {
        public l111l11111I1l() {
        }

        @Override
        public void run() {
            try {
                l1l1l11Il l1l1l11il = l1l1l11Il.this;
                l1l1l11il.l1111l111111Il.postDelayed(l1l1l11il.l11l111l11Il, l1l1l11il.l11l1111I1ll);
                l1l1l11Il.this.l111l1111l1Il();
            } catch (Throwable unused) {
            }
        }
    }

    public class l111l11111Il implements l1l11lIl.l111l11111lIl<Object> {
        public final Set l1111l111111Il;

        public l111l11111Il(Set set) {
            this.l1111l111111Il = set;
        }

        @Override
        public void l1111l111111Il(Object obj) {
            l1l1l11Il.this.l1111l111111Il.removeCallbacksAndMessages(null);
            l1l1l11Il l1l1l11il = l1l1l11Il.this;
            l1l1l11il.l1111l111111Il.postDelayed(l1l1l11il.l11l111l11Il, l1l1l11il.l11l1111I1ll);
            l1l1l11Il.this.l111l1111llIl(this.l1111l111111Il);
        }
    }

    public class l111l11111lIl implements VDataListener {
        public l111l11111lIl() {
        }

        @Override
        public void onResult(JSONObject jSONObject, boolean z) {
            synchronized (l1l1l11Il.class) {
                l1l1l11Il.this.l111l11111lIl(jSONObject, z);
            }
        }
    }

    public class l111l1111l1Il implements l1l11lIl.l1111l111111Il {
        public final Set l1111l111111Il;

        public l111l1111l1Il(Set set) {
            this.l1111l111111Il = set;
        }

        @Override
        public void l1111l111111Il(l1l11I11ll l1l11i11ll) {
            l1l1l11Il.this.l111l1111l1Il(this.l1111l111111Il);
        }
    }

    public class l111l1111llIl extends l1l11I11lll<Object> {
        public l111l1111llIl(int i, String str, String str2, String str3, l1l11lIl.l111l11111lIl l111l11111lil, l1l11lIl.l1111l111111Il l1111l111111il) {
            super(i, str, str2, str3, l111l11111lil, l1111l111111il);
        }

        @Override
        public l1l11lIl<Object> l1111l111111Il(l1l11ll1Il l1l11ll1il) {
            return new l1l11lIl<>(new Object());
        }
    }

    public l1l1l11Il() {
        HandlerThread handlerThread = new HandlerThread("sm-thread-vem");
        this.l111l11111Il = handlerThread;
        handlerThread.start();
        this.l111l11111I1l = new l1111l111111Il(handlerThread.getLooper());
        this.l11l1111I1l = new LinkedList();
        l11l111l11Il l11l111l11ilL111l11111lIl = l11l111l1lll.l1111l111111Il().l111l11111lIl();
        this.l11l1111Il = l11l111l11ilL111l11111lIl.l11l1111Il();
        this.l11l1111I1ll = l11l111l11ilL111l11111lIl.l11l1111Il1l() * 1000;
        this.l11l1111Ill = new l11l111I111l();
        this.l111l1111l1Il = new l11l11l1I1l<>(50);
        this.l111l1111llIl = new l11l11l1I1l<>(10);
        this.l111l1111lI1l = new l11l11l1I1l<>(10);
        this.l111l1111lIl = new l11l11l1I1l<>(10);
        this.l11l1111lIIl = new l11l11l1I1l<>(10);
        this.l11l1111I11l = new l11l11l1I1l<>(10);
    }

    public static synchronized l1l1l11Il l111l11111I1l() {
        if (l111l111I1l == null) {
            l111l111I1l = new l1l1l11Il();
        }
        return l111l111I1l;
    }

    public final Set<JSONObject> l1111l111111Il() {
        HashSet hashSet = new HashSet();
        hashSet.addAll(this.l111l1111l1Il.l1111l111111Il());
        hashSet.addAll(this.l111l1111llIl.l1111l111111Il());
        hashSet.addAll(this.l111l1111lI1l.l1111l111111Il());
        hashSet.addAll(this.l111l1111lIl.l1111l111111Il());
        hashSet.addAll(this.l11l1111lIIl.l1111l111111Il());
        hashSet.addAll(this.l11l1111I11l.l1111l111111Il());
        return hashSet;
    }

    public void l1111l111111Il(AbsDetector absDetector) {
        if (absDetector == null) {
            return;
        }
        absDetector.register(this.l11l11IlIIll);
        try {
            Method declaredMethod = AbsDetector.class.getDeclaredMethod("start", null);
            declaredMethod.setAccessible(true);
            declaredMethod.invoke(absDetector, null);
            this.l11l1111Il1l = 0;
        } catch (Throwable unused) {
        }
        l111l1111llIl();
        this.l11l1111I1l.add(absDetector);
    }

    public final void l1111l111111Il(Set<JSONObject> set) {
        if (set.isEmpty()) {
            return;
        }
        this.l111l1111l1Il.l1111l111111Il(set, 2);
        this.l111l1111llIl.l1111l111111Il(set, 2);
        this.l111l1111lI1l.l1111l111111Il(set, 2);
        this.l111l1111lIl.l1111l111111Il(set, 2);
        this.l11l1111lIIl.l1111l111111Il(set, 2);
        this.l11l1111I11l.l1111l111111Il(set, 2);
    }

    public final void l1111l111111Il(JSONObject jSONObject, boolean z) {
        if (jSONObject == null) {
            return;
        }
        if (z || this.l11l1111Il1l < this.l11l1111Il) {
            String strOptString = jSONObject.optString("eventId", "");
            strOptString.getClass();
            strOptString.hashCode();
            switch (strOptString) {
                case "gpsevent":
                    this.l111l1111lIl.l1111l111111Il(jSONObject, 0);
                    if (!z && this.l111l1111lIl.l111l11111lIl(0, 2) < 10) {
                        return;
                    }
                    break;
                case "textinput":
                    this.l11l1111lIIl.l1111l111111Il(jSONObject, 0);
                    if (!z && this.l11l1111lIIl.l111l11111lIl(0, 2) < 10) {
                        return;
                    }
                    break;
                case "screenrecord":
                    this.l111l1111llIl.l1111l111111Il(jSONObject, 0);
                    if (!z && this.l111l1111llIl.l111l11111lIl(0, 2) < 10) {
                        return;
                    }
                    break;
                case "wevent":
                    this.l111l1111l1Il.l1111l111111Il(jSONObject, 0);
                    if (!z && this.l111l1111l1Il.l111l11111lIl(0, 2) < 50) {
                        return;
                    }
                    break;
                case "screenshot":
                    this.l111l1111lI1l.l1111l111111Il(jSONObject, 0);
                    if (!z && this.l111l1111lI1l.l111l11111lIl(0, 2) < 10) {
                        return;
                    }
                    break;
                case "mem":
                    this.l11l1111I11l.l1111l111111Il(jSONObject, 0);
                    if (!z && this.l11l1111I11l.l111l11111lIl(0, 2) < 10) {
                        return;
                    }
                    break;
                default:
                    return;
            }
            l111l11111Il(l111l11111lIl());
        }
    }

    public final void l111l11111I1l(Set<JSONObject> set) {
        if (set.isEmpty()) {
            return;
        }
        this.l111l1111l1Il.l1111l111111Il(set, 1);
        this.l111l1111llIl.l1111l111111Il(set, 1);
        this.l111l1111lI1l.l1111l111111Il(set, 1);
        this.l111l1111lIl.l1111l111111Il(set, 1);
        this.l11l1111lIIl.l1111l111111Il(set, 1);
        this.l11l1111I11l.l1111l111111Il(set, 1);
    }

    public String l111l11111Il() {
        l111l1111l1Il();
        return l1l1l111Il.l1111l111111Il(l1111l111111Il(), this.l11l1111Ill.l1111l111111Il(), false);
    }

    public final void l111l11111Il(Set<JSONObject> set) {
        if (set.isEmpty()) {
            return;
        }
        try {
            String strL1111l111111Il = l1l1l111Il.l1111l111111Il(set, null, true);
            l111l11111I1l(set);
            this.l11l1111Il1l++;
            l111l1111llIl l111l1111llil = new l111l1111llIl(1, SmAntiFraud.option.getUrl(), SmAntiFraud.option.getRetryUrl(), strL1111l111111Il, new l111l11111Il(set), new l111l1111l1Il(set));
            l111l1111llil.l11l11IlIIll = new l11l111lI1l(2000, 1, 1.0f);
            l11l11ll1ll.l1111l111111Il().l1111l111111Il(l111l1111llil);
        } catch (Throwable unused) {
        }
    }

    public final Set<JSONObject> l111l11111lIl() {
        HashSet hashSet = new HashSet();
        hashSet.addAll(this.l111l1111l1Il.l1111l111111Il(0, 2));
        hashSet.addAll(this.l111l1111llIl.l1111l111111Il(0, 2));
        hashSet.addAll(this.l111l1111lI1l.l1111l111111Il(0, 2));
        hashSet.addAll(this.l111l1111lIl.l1111l111111Il(0, 2));
        hashSet.addAll(this.l11l1111lIIl.l1111l111111Il(0, 2));
        hashSet.addAll(this.l11l1111I11l.l1111l111111Il(0, 2));
        return hashSet;
    }

    public void l111l11111lIl(AbsDetector absDetector) {
        if (absDetector == null) {
            return;
        }
        absDetector.unregister();
        try {
            Method declaredMethod = AbsDetector.class.getDeclaredMethod("stop", null);
            declaredMethod.setAccessible(true);
            declaredMethod.invoke(absDetector, null);
        } catch (Throwable unused) {
        }
        this.l11l1111I1l.remove(absDetector);
        if (this.l11l1111I1l.isEmpty()) {
            l111l1111lI1l();
        }
    }

    public final void l111l11111lIl(Set<JSONObject> set) {
        if (set.isEmpty()) {
            return;
        }
        this.l111l1111l1Il.l1111l111111Il(set);
        this.l111l1111llIl.l1111l111111Il(set);
        this.l111l1111lI1l.l1111l111111Il(set);
        this.l111l1111lIl.l1111l111111Il(set);
        this.l11l1111lIIl.l1111l111111Il(set);
        this.l11l1111I11l.l1111l111111Il(set);
    }

    public final void l111l11111lIl(JSONObject jSONObject, boolean z) {
        Message messageObtain = Message.obtain();
        messageObtain.what = 0;
        messageObtain.obj = jSONObject;
        messageObtain.arg1 = z ? 1 : 0;
        this.l111l11111I1l.sendMessage(messageObtain);
    }

    public final void l111l1111l1Il() {
        Message messageObtain = Message.obtain();
        messageObtain.what = 3;
        this.l111l11111I1l.sendMessage(messageObtain);
    }

    public final void l111l1111l1Il(Set<JSONObject> set) {
        Message messageObtain = Message.obtain();
        messageObtain.what = 1;
        messageObtain.obj = set;
        this.l111l11111I1l.sendMessage(messageObtain);
    }

    public final synchronized void l111l1111lI1l() {
        try {
            if (this.l111l11111lIl == null) {
                return;
            }
            Handler handler = this.l1111l111111Il;
            if (handler != null) {
                handler.removeCallbacksAndMessages(null);
            }
            this.l111l11111lIl.quitSafely();
            this.l111l11111lIl = null;
        } catch (Exception unused) {
        }
    }

    public final synchronized void l111l1111llIl() {
        if (this.l111l11111lIl != null) {
            return;
        }
        HandlerThread handlerThread = new HandlerThread("sm-thread-vem");
        this.l111l11111lIl = handlerThread;
        handlerThread.start();
        Handler handler = new Handler(this.l111l11111lIl.getLooper());
        this.l1111l111111Il = handler;
        handler.postDelayed(this.l11l111l11Il, this.l11l1111I1ll);
    }

    public final void l111l1111llIl(Set<JSONObject> set) {
        Message messageObtain = Message.obtain();
        messageObtain.what = 2;
        messageObtain.obj = set;
        this.l111l11111I1l.sendMessage(messageObtain);
    }
}

package com.ishumei.smantifraud;

import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Collections;
import java.util.Map;

public abstract class l1l11lI1I1l<T> implements Comparable<l1l11lI1I1l<T>> {
    public static final String l111l11IlIlIl = "UTF-8";
    public final l1l1l1lll.l1111l111111Il l1111l111111Il;
    public final String l111l11111I1l;
    public final String l111l11111Il;
    public final int l111l11111lIl;
    public boolean l111l1111l1Il;
    public final Object l111l1111lI1l;
    public l1l11lIl.l1111l111111Il l111l1111lIl;
    public final int l111l1111llIl;
    public l1l11lIIlll l11l1111I11l;
    public boolean l11l1111I1l;
    public boolean l11l1111I1ll;
    public boolean l11l1111Il;
    public boolean l11l1111Il1l;
    public boolean l11l1111Ill;
    public Integer l11l1111lIIl;
    public Object l11l111l11Il;
    public l111l11111I1l l11l111l1lll;
    public l11l11lIl1ll l11l11IlIIll;

    public class l1111l111111Il implements Runnable {
        public final String l1111l111111Il;
        public final long l111l11111lIl;

        public l1111l111111Il(String str, long j) {
            this.l1111l111111Il = str;
            this.l111l11111lIl = j;
        }

        @Override
        public void run() {
            l1l11lI1I1l.this.l1111l111111Il.l1111l111111Il(this.l1111l111111Il, this.l111l11111lIl);
            l1l11lI1I1l l1l11li1i1l = l1l11lI1I1l.this;
            l1l11li1i1l.l1111l111111Il.l1111l111111Il(l1l11li1i1l.toString());
        }
    }

    public interface l111l11111I1l {
        void l1111l111111Il(l1l11lI1I1l<?> l1l11li1i1l);

        void l1111l111111Il(l1l11lI1I1l<?> l1l11li1i1l, l1l11lIl<?> l1l11lil);
    }

    public enum l111l11111Il {
        LOW,
        NORMAL,
        HIGH,
        IMMEDIATE
    }

    public interface l111l11111lIl {
        public static final int l1111l111111Il = -1;
        public static final int l111l11111I1l = 1;
        public static final int l111l11111Il = 2;
        public static final int l111l11111lIl = 0;
        public static final int l111l1111l1Il = 3;
        public static final int l111l1111lI1l = 5;
        public static final int l111l1111lIl = 6;
        public static final int l111l1111llIl = 4;
        public static final int l11l1111lIIl = 7;
    }

    public l1l11lI1I1l(int i, String str, String str2, l1l11lIl.l1111l111111Il l1111l111111il) {
        this.l1111l111111Il = l1l1l1lll.l1111l111111Il.l111l11111I1l ? new l1l1l1lll.l1111l111111Il() : null;
        this.l111l1111lI1l = new Object();
        this.l11l1111I1l = true;
        this.l11l1111I1ll = false;
        this.l11l1111Il = false;
        this.l11l1111Il1l = false;
        this.l11l1111Ill = false;
        this.l111l11111lIl = i;
        this.l111l11111I1l = str;
        this.l111l11111Il = str2;
        this.l111l1111lIl = l1111l111111il;
        l1111l111111Il((l11l11lIl1ll) new l11l111lI1l());
        this.l111l1111llIl = l111l11111lIl(str);
    }

    @Deprecated
    public l1l11lI1I1l(String str, String str2, l1l11lIl.l1111l111111Il l1111l111111il) {
        this(-1, str, str2, l1111l111111il);
    }

    public static int l111l11111lIl(String str) {
        Uri uri;
        String host;
        if (TextUtils.isEmpty(str) || (uri = Uri.parse(str)) == null || (host = uri.getHost()) == null) {
            return 0;
        }
        return host.hashCode();
    }

    public l1l11lI1I1l<?> l1111l111111Il(l11l11lIl1ll l11l11lil1ll) {
        this.l11l11IlIIll = l11l11lil1ll;
        return this;
    }

    public l1l11lI1I1l<?> l1111l111111Il(l1l11lIIlll l1l11liilll) {
        this.l11l1111I11l = l1l11liilll;
        return this;
    }

    public abstract l1l11lIl<T> l1111l111111Il(l1l11ll1Il l1l11ll1il);

    public void l1111l111111Il() {
        synchronized (this.l111l1111lI1l) {
            this.l11l1111I1ll = true;
            this.l111l1111lIl = null;
        }
    }

    public void l1111l111111Il(int i) {
        l1l11lIIlll l1l11liilll = this.l11l1111I11l;
        if (l1l11liilll != null) {
            l1l11liilll.l1111l111111Il(this, i);
        }
    }

    public void l1111l111111Il(l1l11I11ll l1l11i11ll) {
        l1l11lIl.l1111l111111Il l1111l111111il;
        synchronized (this.l111l1111lI1l) {
            l1111l111111il = this.l111l1111lIl;
        }
        if (l1111l111111il != null) {
            l1111l111111il.l1111l111111Il(l1l11i11ll);
        }
    }

    public void l1111l111111Il(l111l11111I1l l111l11111i1l) {
        synchronized (this.l111l1111lI1l) {
            this.l11l111l1lll = l111l11111i1l;
        }
    }

    public void l1111l111111Il(l1l11lIl<?> l1l11lil) {
        l111l11111I1l l111l11111i1l;
        synchronized (this.l111l1111lI1l) {
            l111l11111i1l = this.l11l111l1lll;
        }
        if (l111l11111i1l != null) {
            l111l11111i1l.l1111l111111Il(this, l1l11lil);
        }
    }

    public abstract void l1111l111111Il(T t);

    public void l1111l111111Il(String str) {
        if (l1l1l1lll.l1111l111111Il.l111l11111I1l) {
            this.l1111l111111Il.l1111l111111Il(str, Thread.currentThread().getId());
        }
    }

    public void l1111l111111Il(boolean z) {
        this.l111l1111l1Il = z;
    }

    public final byte[] l1111l111111Il(Map<String, String> map, String str) {
        StringBuilder sb = new StringBuilder();
        try {
            for (Map.Entry<String, String> entry : map.entrySet()) {
                if (entry.getKey() == null || entry.getValue() == null) {
                    throw new IllegalArgumentException(String.format("Request#getParams() or Request#getPostParams() returned a map containing a null key or value: (%s, %s). All keys and values must be non-null.", entry.getKey(), entry.getValue()));
                }
                sb.append(URLEncoder.encode(entry.getKey(), str));
                sb.append('=');
                sb.append(URLEncoder.encode(entry.getValue(), str));
                sb.append('&');
            }
            return sb.toString().getBytes(str);
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("Encoding not supported: " + str, e);
        }
    }

    public final l1l11lI1I1l<?> l111l11111I1l(boolean z) {
        this.l11l1111Ill = z;
        return this;
    }

    public String l111l11111I1l() {
        return "application/x-www-form-urlencoded; charset=" + l11l1111lIIl();
    }

    public void l111l11111I1l(String str) {
        l1l11lIIlll l1l11liilll = this.l11l1111I11l;
        if (l1l11liilll != null) {
            l1l11liilll.l111l11111I1l(this);
        }
        if (l1l1l1lll.l1111l111111Il.l111l11111I1l) {
            long id = Thread.currentThread().getId();
            if (Looper.myLooper() != Looper.getMainLooper()) {
                new Handler(Looper.getMainLooper()).post(new l1111l111111Il(str, id));
            } else {
                this.l1111l111111Il.l1111l111111Il(str, id);
                this.l1111l111111Il.l1111l111111Il(toString());
            }
        }
    }

    public final l1l11lI1I1l<?> l111l11111Il(boolean z) {
        this.l11l1111Il1l = z;
        return this;
    }

    public String l111l11111Il() {
        String strL11l111l1Il = l11l111l1Il();
        int iL111l1111lI1l = l111l1111lI1l();
        if (iL111l1111lI1l == 0 || iL111l1111lI1l == -1) {
            return strL11l111l1Il;
        }
        return Integer.toString(iL111l1111lI1l) + '-' + strL11l111l1Il;
    }

    @Override
    public int compareTo(l1l11lI1I1l<T> l1l11li1i1l) {
        l111l11111Il l111l11111ilL11l1111Il1l = l11l1111Il1l();
        l111l11111Il l111l11111ilL11l1111Il1l2 = l1l11li1i1l.l11l1111Il1l();
        return l111l11111ilL11l1111Il1l == l111l11111ilL11l1111Il1l2 ? this.l11l1111lIIl.intValue() - l1l11li1i1l.l11l1111lIIl.intValue() : l111l11111ilL11l1111Il1l2.ordinal() - l111l11111ilL11l1111Il1l.ordinal();
    }

    public l1l11I11ll l111l11111lIl(l1l11I11ll l1l11i11ll) {
        return l1l11i11ll;
    }

    public final l1l11lI1I1l<?> l111l11111lIl(int i) {
        this.l11l1111lIIl = Integer.valueOf(i);
        return this;
    }

    public l1l11lI1I1l<?> l111l11111lIl(Object obj) {
        this.l11l111l11Il = obj;
        return this;
    }

    public final l1l11lI1I1l<?> l111l11111lIl(boolean z) {
        this.l11l1111I1l = z;
        return this;
    }

    public byte[] l111l11111lIl() {
        Map<String, String> mapL111l1111lIl = l111l1111lIl();
        if (mapL111l1111lIl == null || mapL111l1111lIl.size() <= 0) {
            return null;
        }
        return l1111l111111Il(mapL111l1111lIl, l11l1111lIIl());
    }

    public l1l11lIl.l1111l111111Il l111l1111l1Il() {
        l1l11lIl.l1111l111111Il l1111l111111il;
        synchronized (this.l111l1111lI1l) {
            l1111l111111il = this.l111l1111lIl;
        }
        return l1111l111111il;
    }

    public int l111l1111lI1l() {
        return this.l111l11111lIl;
    }

    public Map<String, String> l111l1111lIl() {
        return null;
    }

    public Map<String, String> l111l1111llIl() {
        return Collections.emptyMap();
    }

    public final boolean l111l111llIl() {
        return this.l11l1111Ill;
    }

    public final int l111l11IlIlIl() {
        return l11l1111Ill().l1111l111111Il();
    }

    @Deprecated
    public byte[] l11l1111I11l() {
        Map<String, String> mapL11l1111I1ll = l11l1111I1ll();
        if (mapL11l1111I1ll == null || mapL11l1111I1ll.size() <= 0) {
            return null;
        }
        return l1111l111111Il(mapL11l1111I1ll, l11l1111Il());
    }

    @Deprecated
    public String l11l1111I1l() {
        return l111l11111I1l();
    }

    @Deprecated
    public Map<String, String> l11l1111I1ll() {
        return l111l1111lIl();
    }

    @Deprecated
    public String l11l1111Il() {
        return l11l1111lIIl();
    }

    public l111l11111Il l11l1111Il1l() {
        return l111l11111Il.NORMAL;
    }

    public l11l11lIl1ll l11l1111Ill() {
        return this.l11l11IlIIll;
    }

    public String l11l1111lIIl() {
        return "UTF-8";
    }

    public final int l11l111l11Il() {
        Integer num = this.l11l1111lIIl;
        if (num != null) {
            return num.intValue();
        }
        throw new IllegalStateException("getSequence called before setSequence");
    }

    public int l11l111l1I1l() {
        return this.l111l1111llIl;
    }

    public String l11l111l1Il() {
        return this.l111l11111I1l;
    }

    public Object l11l111l1lll() {
        return this.l11l111l11Il;
    }

    public final boolean l11l111lI1l() {
        return this.l11l1111Il1l;
    }

    public boolean l11l111ll11l() {
        boolean z;
        synchronized (this.l111l1111lI1l) {
            z = this.l11l1111Il;
        }
        return z;
    }

    public boolean l11l111ll1Il() {
        boolean z;
        synchronized (this.l111l1111lI1l) {
            z = this.l11l1111I1ll;
        }
        return z;
    }

    public void l11l111llI1l() {
        l111l11111I1l l111l11111i1l;
        synchronized (this.l111l1111lI1l) {
            l111l11111i1l = this.l11l111l1lll;
        }
        if (l111l11111i1l != null) {
            l111l11111i1l.l1111l111111Il(this);
        }
    }

    public boolean l11l111lll() {
        return this.l111l1111l1Il;
    }

    public void l11l111lllIl() {
        synchronized (this.l111l1111lI1l) {
            this.l11l1111Il = true;
        }
    }

    public String l11l11IlIIll() {
        return this.l111l11111Il;
    }

    public String toString() {
        String str = "0x" + Integer.toHexString(l11l111l1I1l());
        StringBuilder sb = new StringBuilder();
        sb.append(l11l111ll1Il() ? "[X] " : "[ ] ");
        sb.append(l11l111l1Il());
        sb.append(" ");
        sb.append(str);
        sb.append(" ");
        sb.append(l11l1111Il1l());
        sb.append(" ");
        sb.append(this.l11l1111lIIl);
        return sb.toString();
    }
}

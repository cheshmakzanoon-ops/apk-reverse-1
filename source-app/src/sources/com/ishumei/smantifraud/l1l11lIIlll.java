package com.ishumei.smantifraud;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.concurrent.PriorityBlockingQueue;
import java.util.concurrent.atomic.AtomicInteger;

public class l1l11lIIlll {
    public static final int l11l1111lIIl = 2;
    public final AtomicInteger l1111l111111Il;
    public final PriorityBlockingQueue<l1l11lI1I1l<?>> l111l11111I1l;
    public final l1l11l1Il1l l111l11111Il;
    public final Set<l1l11lI1I1l<?>> l111l11111lIl;
    public final l1l11lIl1Il l111l1111l1Il;
    public final List<l111l1111l1Il> l111l1111lI1l;
    public final List<l111l11111I1l> l111l1111lIl;
    public final l1l11l1IIl[] l111l1111llIl;

    public class l1111l111111Il implements l111l11111Il {
        public final Object l1111l111111Il;

        public l1111l111111Il(Object obj) {
            this.l1111l111111Il = obj;
        }

        @Override
        public boolean l1111l111111Il(l1l11lI1I1l<?> l1l11li1i1l) {
            return l1l11li1i1l.l11l111l1lll() == this.l1111l111111Il;
        }
    }

    public interface l111l11111I1l {
        void l1111l111111Il(l1l11lI1I1l<?> l1l11li1i1l, int i);
    }

    public interface l111l11111Il {
        boolean l1111l111111Il(l1l11lI1I1l<?> l1l11li1i1l);
    }

    @Retention(RetentionPolicy.SOURCE)
    public @interface l111l11111lIl {
        public static final int l1111l111111Il = 0;
        public static final int l111l11111I1l = 2;
        public static final int l111l11111Il = 3;
        public static final int l111l11111lIl = 1;
        public static final int l111l1111l1Il = 4;
        public static final int l111l1111llIl = 5;
    }

    @Deprecated
    public interface l111l1111l1Il<T> {
        void l1111l111111Il(l1l11lI1I1l<T> l1l11li1i1l);
    }

    public l1l11lIIlll(l1l11l1Il1l l1l11l1il1l) {
        this(l1l11l1il1l, 2);
    }

    public l1l11lIIlll(l1l11l1Il1l l1l11l1il1l, int i) {
        this(l1l11l1il1l, i, new l11l111Il());
    }

    public l1l11lIIlll(l1l11l1Il1l l1l11l1il1l, int i, l1l11lIl1Il l1l11lil1il) {
        this.l1111l111111Il = new AtomicInteger();
        this.l111l11111lIl = new HashSet();
        this.l111l11111I1l = new PriorityBlockingQueue<>();
        this.l111l1111lI1l = new ArrayList();
        this.l111l1111lIl = new ArrayList();
        this.l111l11111Il = l1l11l1il1l;
        this.l111l1111llIl = new l1l11l1IIl[i];
        this.l111l1111l1Il = l1l11lil1il;
    }

    public <T> l1l11lI1I1l<T> l1111l111111Il(l1l11lI1I1l<T> l1l11li1i1l) {
        l1l11li1i1l.l1111l111111Il(this);
        synchronized (this.l111l11111lIl) {
            this.l111l11111lIl.add(l1l11li1i1l);
        }
        l1l11li1i1l.l111l11111lIl(l111l11111lIl());
        l1l11li1i1l.l1111l111111Il("add-to-queue");
        l1111l111111Il(l1l11li1i1l, 0);
        l111l11111lIl(l1l11li1i1l);
        return l1l11li1i1l;
    }

    public l1l11lIl1Il l1111l111111Il() {
        return this.l111l1111l1Il;
    }

    public void l1111l111111Il(l1l11lI1I1l<?> l1l11li1i1l, int i) {
        synchronized (this.l111l1111lIl) {
            Iterator<l111l11111I1l> it = this.l111l1111lIl.iterator();
            while (it.hasNext()) {
                it.next().l1111l111111Il(l1l11li1i1l, i);
            }
        }
    }

    public void l1111l111111Il(l111l11111I1l l111l11111i1l) {
        synchronized (this.l111l1111lIl) {
            this.l111l1111lIl.add(l111l11111i1l);
        }
    }

    public void l1111l111111Il(l111l11111Il l111l11111il) {
        synchronized (this.l111l11111lIl) {
            for (l1l11lI1I1l<?> l1l11li1i1l : this.l111l11111lIl) {
                if (l111l11111il.l1111l111111Il(l1l11li1i1l)) {
                    l1l11li1i1l.l1111l111111Il();
                }
            }
        }
    }

    @Deprecated
    public <T> void l1111l111111Il(l111l1111l1Il<T> l111l1111l1il) {
        synchronized (this.l111l1111lI1l) {
            this.l111l1111lI1l.add(l111l1111l1il);
        }
    }

    public void l1111l111111Il(Object obj) {
        if (obj == null) {
            throw new IllegalArgumentException("Cannot cancelAll with a null tag");
        }
        l1111l111111Il((l111l11111Il) new l1111l111111Il(obj));
    }

    public <T> void l111l11111I1l(l1l11lI1I1l<T> l1l11li1i1l) {
        synchronized (this.l111l11111lIl) {
            this.l111l11111lIl.remove(l1l11li1i1l);
        }
        synchronized (this.l111l1111lI1l) {
            Iterator<l111l1111l1Il> it = this.l111l1111lI1l.iterator();
            while (it.hasNext()) {
                it.next().l1111l111111Il(l1l11li1i1l);
            }
        }
        l1111l111111Il(l1l11li1i1l, 5);
    }

    public boolean l111l11111I1l() {
        return true;
    }

    public synchronized void l111l11111Il() {
        l111l1111l1Il();
        int i = 0;
        while (i < this.l111l1111llIl.length) {
            l1l11l1IIl l1l11l1iil = new l1l11l1IIl(this.l111l11111I1l, this.l111l11111Il, this.l111l1111l1Il);
            StringBuilder sb = new StringBuilder("sm-thread-http");
            int i2 = i + 1;
            sb.append(i2);
            l1l11l1iil.setName(sb.toString());
            this.l111l1111llIl[i] = l1l11l1iil;
            l1l11l1iil.start();
            i = i2;
        }
    }

    public <T> void l111l11111Il(l1l11lI1I1l<T> l1l11li1i1l) {
        this.l111l11111I1l.add(l1l11li1i1l);
    }

    public int l111l11111lIl() {
        return this.l1111l111111Il.incrementAndGet();
    }

    public <T> void l111l11111lIl(l1l11lI1I1l<T> l1l11li1i1l) {
        l111l11111Il(l1l11li1i1l);
    }

    public void l111l11111lIl(l111l11111I1l l111l11111i1l) {
        synchronized (this.l111l1111lIl) {
            this.l111l1111lIl.remove(l111l11111i1l);
        }
    }

    @Deprecated
    public <T> void l111l11111lIl(l111l1111l1Il<T> l111l1111l1il) {
        synchronized (this.l111l1111lI1l) {
            this.l111l1111lI1l.remove(l111l1111l1il);
        }
    }

    public void l111l1111l1Il() {
        for (l1l11l1IIl l1l11l1iil : this.l111l1111llIl) {
            if (l1l11l1iil != null) {
                l1l11l1iil.l111l11111lIl();
            }
        }
    }
}

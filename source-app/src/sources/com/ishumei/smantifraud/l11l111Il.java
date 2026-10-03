package com.ishumei.smantifraud;

import java.util.concurrent.Executor;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class l11l111Il implements l1l11lIl1Il {
    public final Executor l1111l111111Il = new ThreadPoolExecutor(0, 1, 5000, TimeUnit.MILLISECONDS, new LinkedBlockingQueue(), new ThreadFactory() {
        @Override
        public final Thread newThread(Runnable runnable) {
            return l11l111Il.l1111l111111Il(runnable);
        }
    }, new ThreadPoolExecutor.DiscardOldestPolicy());

    public static class l1111l111111Il implements Runnable {
        public final l1l11lI1I1l l1111l111111Il;
        public final Runnable l111l11111I1l;
        public final l1l11lIl l111l11111lIl;

        public l1111l111111Il(l1l11lI1I1l l1l11li1i1l, l1l11lIl l1l11lil, Runnable runnable) {
            this.l1111l111111Il = l1l11li1i1l;
            this.l111l11111lIl = l1l11lil;
            this.l111l11111I1l = runnable;
        }

        @Override
        public void run() {
            if (this.l1111l111111Il.l11l111ll1Il()) {
                this.l1111l111111Il.l111l11111I1l("canceled-at-delivery");
                return;
            }
            if (this.l111l11111lIl.l1111l111111Il()) {
                this.l1111l111111Il.l1111l111111Il(this.l111l11111lIl.l1111l111111Il);
            } else {
                this.l1111l111111Il.l1111l111111Il(this.l111l11111lIl.l111l11111lIl);
            }
            if (this.l111l11111lIl.l111l11111I1l) {
                this.l1111l111111Il.l1111l111111Il("intermediate-response");
            } else {
                this.l1111l111111Il.l111l11111I1l("done");
            }
            Runnable runnable = this.l111l11111I1l;
            if (runnable != null) {
                runnable.run();
            }
        }
    }

    public static Thread l1111l111111Il(Runnable runnable) {
        return new Thread(runnable, "sm-thread-p-ed");
    }

    @Override
    public void l1111l111111Il(l1l11lI1I1l<?> l1l11li1i1l, l1l11I11ll l1l11i11ll) {
        l1l11li1i1l.l1111l111111Il("post-error");
        this.l1111l111111Il.execute(new l1111l111111Il(l1l11li1i1l, new l1l11lIl(l1l11i11ll), null));
    }

    @Override
    public void l1111l111111Il(l1l11lI1I1l<?> l1l11li1i1l, l1l11lIl<?> l1l11lil) {
        l1111l111111Il(l1l11li1i1l, l1l11lil, null);
    }

    @Override
    public void l1111l111111Il(l1l11lI1I1l<?> l1l11li1i1l, l1l11lIl<?> l1l11lil, Runnable runnable) {
        l1l11li1i1l.l11l111lllIl();
        l1l11li1i1l.l1111l111111Il("post-response");
        this.l1111l111111Il.execute(new l1111l111111Il(l1l11li1i1l, l1l11lil, runnable));
    }
}

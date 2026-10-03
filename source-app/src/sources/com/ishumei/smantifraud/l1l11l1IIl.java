package com.ishumei.smantifraud;

import android.net.TrafficStats;
import android.os.Process;
import android.os.SystemClock;
import android.text.TextUtils;
import java.util.concurrent.BlockingQueue;

public class l1l11l1IIl extends Thread {
    public final BlockingQueue<l1l11lI1I1l<?>> l1111l111111Il;
    public final l1l11lIl1Il l111l11111I1l;
    public volatile boolean l111l11111Il = false;
    public final l1l11l1Il1l l111l11111lIl;

    public l1l11l1IIl(BlockingQueue<l1l11lI1I1l<?>> blockingQueue, l1l11l1Il1l l1l11l1il1l, l1l11lIl1Il l1l11lil1il) {
        this.l1111l111111Il = blockingQueue;
        this.l111l11111lIl = l1l11l1il1l;
        this.l111l11111I1l = l1l11lil1il;
    }

    public final void l1111l111111Il() throws InterruptedException {
        l111l11111lIl(this.l1111l111111Il.take());
    }

    public final void l1111l111111Il(l1l11lI1I1l<?> l1l11li1i1l) {
        TrafficStats.setThreadStatsTag(l1l11li1i1l.l11l111l1I1l());
    }

    public void l111l11111lIl() {
        this.l111l11111Il = true;
        interrupt();
    }

    public void l111l11111lIl(l1l11lI1I1l<?> l1l11li1i1l) {
        SystemClock.elapsedRealtime();
        l1l11li1i1l.l1111l111111Il(3);
        try {
            try {
                l1l11li1i1l.l1111l111111Il("network-queue-take");
                if (l1l11li1i1l.l11l111ll1Il()) {
                    l1l11li1i1l.l111l11111I1l("network-discard-cancelled");
                    l1l11li1i1l.l11l111llI1l();
                    l1l11li1i1l.l1111l111111Il(4);
                    return;
                }
                l1111l111111Il(l1l11li1i1l);
                l1l11lIl<?> l1l11lilL1111l111111Il = this.l111l11111lIl.l1111l111111Il(l1l11li1i1l);
                l1l11li1i1l.l1111l111111Il("network-http-complete");
                l1l11li1i1l.l11l111lllIl();
                this.l111l11111I1l.l1111l111111Il(l1l11li1i1l, l1l11lilL1111l111111Il);
                l1l11li1i1l.l1111l111111Il(l1l11lilL1111l111111Il);
                l1l11li1i1l.l1111l111111Il(4);
            } catch (l1l11I11ll e) {
                this.l111l11111I1l.l1111l111111Il(l1l11li1i1l, e);
                l1l11li1i1l.l11l111llI1l();
            } catch (Exception e2) {
                l1l1l1lll.l1111l111111Il(e2, "Unhandled exception %s", e2.toString());
                this.l111l11111I1l.l1111l111111Il(l1l11li1i1l, ((e2 instanceof IllegalArgumentException) && TextUtils.equals(e2.getMessage(), l1l11I11ll.l111l1111lI1l)) ? new l1l11I11ll(l1l11I11ll.l111l1111lI1l, -3) : new l1l11I11ll(e2, -4));
                l1l11li1i1l.l11l111llI1l();
            }
        } catch (Throwable th) {
            l1l11li1i1l.l1111l111111Il(4);
            throw th;
        }
    }

    @Override
    public void run() {
        Process.setThreadPriority(10);
        while (true) {
            try {
                l1111l111111Il();
            } catch (InterruptedException unused) {
                if (this.l111l11111Il) {
                    Thread.currentThread().interrupt();
                    return;
                }
                l1l1l1lll.l111l11111I1l("Ignoring spurious interrupt of NetworkDispatcher thread; use quit() to terminate it", new Object[0]);
            }
        }
    }
}

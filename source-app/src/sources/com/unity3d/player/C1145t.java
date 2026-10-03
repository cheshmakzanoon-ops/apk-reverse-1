package com.unity3d.player;

import android.app.Activity;
import android.content.Context;
import java.util.concurrent.Semaphore;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

final class C1145t {

    private UnityPlayer f520a;

    private a f522c;

    private Context f521b = null;

    private final Semaphore f523d = new Semaphore(0);

    private final Lock f524e = new ReentrantLock();

    private SurfaceHolderCallbackC1144s f525f = null;

    private int f526g = 2;

    private boolean f527h = false;

    private boolean f528i = false;

    final class AnonymousClass1 implements Runnable {

        final String f529a;

        final int f530b;

        final int f531c;

        final int f532d;

        final boolean f533e;

        final long f534f;

        final long f535g;

        AnonymousClass1(String str, int i, int i2, int i3, boolean z, long j, long j2) {
            this.f529a = str;
            this.f530b = i;
            this.f531c = i2;
            this.f532d = i3;
            this.f533e = z;
            this.f534f = j;
            this.f535g = j2;
        }

        @Override
        public final void run() {
            if (C1145t.this.f525f != null) {
                C1134i.Log(5, "Video already playing");
                C1145t.this.f526g = 2;
                C1145t.this.f523d.release();
            } else {
                C1145t.this.f525f = new SurfaceHolderCallbackC1144s(C1145t.this.f521b, this.f529a, this.f530b, this.f531c, this.f532d, this.f533e, this.f534f, this.f535g, new SurfaceHolderCallbackC1144s.a() {
                    @Override
                    public final void mo699a(int i) {
                        C1145t.this.f524e.lock();
                        C1145t.this.f526g = i;
                        if (i == 3 && C1145t.this.f528i) {
                            C1145t.this.runOnUiThread(new Runnable() {
                                @Override
                                public final void run() {
                                    C1145t.this.m707d();
                                    C1145t.this.f520a.resume();
                                }
                            });
                        }
                        if (i != 0) {
                            C1145t.this.f523d.release();
                        }
                        C1145t.this.f524e.unlock();
                    }
                });
                if (C1145t.this.f525f != null) {
                    C1145t.this.f520a.addView(C1145t.this.f525f);
                }
            }
        }
    }

    public interface a {
        void mo492a();
    }

    C1145t(UnityPlayer unityPlayer) {
        this.f520a = null;
        this.f520a = unityPlayer;
    }

    public void m707d() {
        SurfaceHolderCallbackC1144s surfaceHolderCallbackC1144s = this.f525f;
        if (surfaceHolderCallbackC1144s != null) {
            this.f520a.removeViewFromPlayer(surfaceHolderCallbackC1144s);
            this.f528i = false;
            this.f525f.destroyPlayer();
            this.f525f = null;
            a aVar = this.f522c;
            if (aVar != null) {
                aVar.mo492a();
            }
        }
    }

    static boolean m711h(C1145t c1145t) {
        c1145t.f528i = true;
        return true;
    }

    public final void m712a() {
        this.f524e.lock();
        SurfaceHolderCallbackC1144s surfaceHolderCallbackC1144s = this.f525f;
        if (surfaceHolderCallbackC1144s != null) {
            if (this.f526g == 0) {
                surfaceHolderCallbackC1144s.CancelOnPrepare();
            } else if (this.f528i) {
                boolean zM698a = surfaceHolderCallbackC1144s.m698a();
                this.f527h = zM698a;
                if (!zM698a) {
                    this.f525f.pause();
                }
            }
        }
        this.f524e.unlock();
    }

    public final boolean m713a(Context context, String str, int i, int i2, int i3, boolean z, long j, long j2, a aVar) {
        this.f524e.lock();
        this.f522c = aVar;
        this.f521b = context;
        this.f523d.drainPermits();
        this.f526g = 2;
        runOnUiThread(new AnonymousClass1(str, i, i2, i3, z, j, j2));
        boolean z2 = false;
        try {
            this.f524e.unlock();
            this.f523d.acquire();
            this.f524e.lock();
            if (this.f526g != 2) {
                z2 = true;
            }
        } catch (InterruptedException unused) {
        }
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                C1145t.this.f520a.pause();
            }
        });
        runOnUiThread((!z2 || this.f526g == 3) ? new Runnable() {
            @Override
            public final void run() {
                C1145t.this.m707d();
                C1145t.this.f520a.resume();
            }
        } : new Runnable() {
            @Override
            public final void run() {
                if (C1145t.this.f525f != null) {
                    C1145t.this.f520a.addViewToPlayer(C1145t.this.f525f, true);
                    C1145t.m711h(C1145t.this);
                    C1145t.this.f525f.requestFocus();
                }
            }
        });
        this.f524e.unlock();
        return z2;
    }

    public final void m714b() {
        this.f524e.lock();
        SurfaceHolderCallbackC1144s surfaceHolderCallbackC1144s = this.f525f;
        if (surfaceHolderCallbackC1144s != null && this.f528i && !this.f527h) {
            surfaceHolderCallbackC1144s.start();
        }
        this.f524e.unlock();
    }

    public final void m715c() {
        this.f524e.lock();
        SurfaceHolderCallbackC1144s surfaceHolderCallbackC1144s = this.f525f;
        if (surfaceHolderCallbackC1144s != null) {
            surfaceHolderCallbackC1144s.updateVideoLayout();
        }
        this.f524e.unlock();
    }

    protected final void runOnUiThread(Runnable runnable) {
        Context context = this.f521b;
        if (context instanceof Activity) {
            ((Activity) context).runOnUiThread(runnable);
        } else {
            C1134i.Log(5, "Not running from an Activity; Ignoring execution request...");
        }
    }
}

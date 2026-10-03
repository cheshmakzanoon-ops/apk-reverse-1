package com.google.android.gms.measurement.internal;

import android.content.Context;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.util.Clock;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.Callable;
import java.util.concurrent.Future;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.PriorityBlockingQueue;
import java.util.concurrent.Semaphore;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReference;
import org.checkerframework.dataflow.qual.Pure;

public final class zzgy extends zzic {
    private static final AtomicLong zza = new AtomicLong(Long.MIN_VALUE);
    private zzhc zzb;
    private zzhc zzc;
    private final PriorityBlockingQueue<zzhd<?>> zzd;
    private final BlockingQueue<zzhd<?>> zze;
    private final Thread.UncaughtExceptionHandler zzf;
    private final Thread.UncaughtExceptionHandler zzg;
    private final Object zzh;
    private final Semaphore zzi;
    private volatile boolean zzj;

    @Override
    @Pure
    public final Context zza() {
        return super.zza();
    }

    @Override
    protected final boolean zzo() {
        return false;
    }

    @Override
    @Pure
    public final Clock zzb() {
        return super.zzb();
    }

    @Override
    @Pure
    public final zzae zzd() {
        return super.zzd();
    }

    @Override
    @Pure
    public final zzaf zze() {
        return super.zze();
    }

    @Override
    @Pure
    public final zzba zzf() {
        return super.zzf();
    }

    @Override
    @Pure
    public final zzfq zzi() {
        return super.zzi();
    }

    @Override
    @Pure
    public final zzfr zzj() {
        return super.zzj();
    }

    @Override
    @Pure
    public final zzgd zzk() {
        return super.zzk();
    }

    @Override
    @Pure
    public final zzgy zzl() {
        return super.zzl();
    }

    @Override
    @Pure
    public final zznd zzq() {
        return super.zzq();
    }

    final <T> T zza(AtomicReference<T> atomicReference, long j, String str, Runnable runnable) {
        synchronized (atomicReference) {
            zzl().zzb(runnable);
            try {
                atomicReference.wait(j);
            } catch (InterruptedException unused) {
                zzj().zzu().zza("Interrupted waiting for " + str);
                return null;
            }
        }
        T t = atomicReference.get();
        if (t == null) {
            zzj().zzu().zza("Timed out waiting for " + str);
        }
        return t;
    }

    public final <V> Future<V> zza(Callable<V> callable) throws IllegalStateException {
        zzab();
        Preconditions.checkNotNull(callable);
        zzhd<?> zzhdVar = new zzhd<>(this, (Callable<?>) callable, false, "Task exception on worker thread");
        if (Thread.currentThread() == this.zzb) {
            if (!this.zzd.isEmpty()) {
                zzj().zzu().zza("Callable skipped the worker queue.");
            }
            zzhdVar.run();
        } else {
            zza(zzhdVar);
        }
        return zzhdVar;
    }

    public final <V> Future<V> zzb(Callable<V> callable) throws IllegalStateException {
        zzab();
        Preconditions.checkNotNull(callable);
        zzhd<?> zzhdVar = new zzhd<>(this, (Callable<?>) callable, true, "Task exception on worker thread");
        if (Thread.currentThread() == this.zzb) {
            zzhdVar.run();
        } else {
            zza(zzhdVar);
        }
        return zzhdVar;
    }

    zzgy(zzhf zzhfVar) {
        super(zzhfVar);
        this.zzh = new Object();
        this.zzi = new Semaphore(2);
        this.zzd = new PriorityBlockingQueue<>();
        this.zze = new LinkedBlockingQueue();
        this.zzf = new zzha(this, "Thread death: Uncaught exception on worker thread");
        this.zzg = new zzha(this, "Thread death: Uncaught exception on network thread");
    }

    @Override
    public final void zzr() {
        if (Thread.currentThread() != this.zzc) {
            throw new IllegalStateException("Call expected from network thread");
        }
    }

    @Override
    public final void zzs() {
        super.zzs();
    }

    @Override
    public final void zzt() {
        if (Thread.currentThread() != this.zzb) {
            throw new IllegalStateException("Call expected from worker thread");
        }
    }

    private final void zza(zzhd<?> zzhdVar) {
        synchronized (this.zzh) {
            this.zzd.add(zzhdVar);
            zzhc zzhcVar = this.zzb;
            if (zzhcVar == null) {
                zzhc zzhcVar2 = new zzhc(this, "Measurement Worker", this.zzd);
                this.zzb = zzhcVar2;
                zzhcVar2.setUncaughtExceptionHandler(this.zzf);
                this.zzb.start();
            } else {
                zzhcVar.zza();
            }
        }
    }

    public final void zza(Runnable runnable) throws IllegalStateException {
        zzab();
        Preconditions.checkNotNull(runnable);
        zzhd<?> zzhdVar = new zzhd<>(this, runnable, false, "Task exception on network thread");
        synchronized (this.zzh) {
            this.zze.add(zzhdVar);
            zzhc zzhcVar = this.zzc;
            if (zzhcVar == null) {
                zzhc zzhcVar2 = new zzhc(this, "Measurement Network", this.zze);
                this.zzc = zzhcVar2;
                zzhcVar2.setUncaughtExceptionHandler(this.zzg);
                this.zzc.start();
            } else {
                zzhcVar.zza();
            }
        }
    }

    public final void zzb(Runnable runnable) throws IllegalStateException {
        zzab();
        Preconditions.checkNotNull(runnable);
        zza(new zzhd<>(this, runnable, false, "Task exception on worker thread"));
    }

    public final void zzc(Runnable runnable) throws IllegalStateException {
        zzab();
        Preconditions.checkNotNull(runnable);
        zza(new zzhd<>(this, runnable, true, "Task exception on worker thread"));
    }

    public final boolean zzg() {
        return Thread.currentThread() == this.zzb;
    }
}

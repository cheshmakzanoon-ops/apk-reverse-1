package com.google.android.gms.internal.play_billing;

import j$.util.Objects;
import java.lang.reflect.Field;
import java.security.AccessController;
import java.security.PrivilegedActionException;
import java.security.PrivilegedExceptionAction;
import java.util.Locale;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import java.util.concurrent.atomic.AtomicReferenceFieldUpdater;
import java.util.concurrent.locks.LockSupport;
import java.util.logging.Level;
import sun.misc.Unsafe;

abstract class zzcn<V> extends zzdi implements zzdc<V> {
    static final Object zza = new Object();
    static final zzdb zzb = new zzdb(zzcm.class);
    static final boolean zzc;
    private static final zza zzd;
    volatile zzcm.zzd listenersField;
    volatile Object valueField;
    volatile zze waitersField;

    abstract class zza {
        zza(zzcr zzcrVar) {
        }

        abstract zzcm.zzd zza(zzcn zzcnVar, zzcm.zzd zzdVar);

        abstract zze zzb(zzcn zzcnVar, zze zzeVar);

        abstract void zzc(zze zzeVar, zze zzeVar2);

        abstract void zzd(zze zzeVar, Thread thread);

        abstract boolean zze(zzcn zzcnVar, zzcm.zzd zzdVar, zzcm.zzd zzdVar2);

        abstract boolean zzf(zzcn zzcnVar, Object obj, Object obj2);

        abstract boolean zzg(zzcn zzcnVar, zze zzeVar, zze zzeVar2);
    }

    final class zzb extends zza {
        private static final AtomicReferenceFieldUpdater<zze, Thread> zza = AtomicReferenceFieldUpdater.newUpdater(zze.class, Thread.class, "thread");
        private static final AtomicReferenceFieldUpdater<zze, zze> zzb = AtomicReferenceFieldUpdater.newUpdater(zze.class, zze.class, "next");
        private static final AtomicReferenceFieldUpdater<? super zzcn<?>, zze> zzc = AtomicReferenceFieldUpdater.newUpdater(zzcn.class, zze.class, "waitersField");
        private static final AtomicReferenceFieldUpdater<? super zzcn<?>, zzcm.zzd> zzd = AtomicReferenceFieldUpdater.newUpdater(zzcn.class, zzcm.zzd.class, "listenersField");
        private static final AtomicReferenceFieldUpdater<? super zzcn<?>, Object> zze = AtomicReferenceFieldUpdater.newUpdater(zzcn.class, Object.class, "valueField");

        private zzb() {
            throw null;
        }

        zzb(zzcr zzcrVar) {
            super(null);
        }

        @Override
        final zzcm.zzd zza(zzcn zzcnVar, zzcm.zzd zzdVar) {
            return zzd.getAndSet(zzcnVar, zzdVar);
        }

        @Override
        final zze zzb(zzcn zzcnVar, zze zzeVar) {
            return zzc.getAndSet(zzcnVar, zzeVar);
        }

        @Override
        final void zzc(zze zzeVar, zze zzeVar2) {
            zzb.lazySet(zzeVar, zzeVar2);
        }

        @Override
        final void zzd(zze zzeVar, Thread thread) {
            zza.lazySet(zzeVar, thread);
        }

        @Override
        final boolean zze(zzcn zzcnVar, zzcm.zzd zzdVar, zzcm.zzd zzdVar2) {
            return zzco.zza(zzd, zzcnVar, zzdVar, zzdVar2);
        }

        @Override
        final boolean zzf(zzcn zzcnVar, Object obj, Object obj2) {
            return zzco.zza(zze, zzcnVar, obj, obj2);
        }

        @Override
        final boolean zzg(zzcn zzcnVar, zze zzeVar, zze zzeVar2) {
            return zzco.zza(zzc, zzcnVar, zzeVar, zzeVar2);
        }
    }

    final class zzc extends zza {
        private zzc() {
            throw null;
        }

        zzc(zzcr zzcrVar) {
            super(null);
        }

        @Override
        final zzcm.zzd zza(zzcn zzcnVar, zzcm.zzd zzdVar) {
            zzcm.zzd zzdVar2;
            synchronized (zzcnVar) {
                zzdVar2 = zzcnVar.listenersField;
                if (zzdVar2 != zzdVar) {
                    zzcnVar.listenersField = zzdVar;
                }
            }
            return zzdVar2;
        }

        @Override
        final zze zzb(zzcn zzcnVar, zze zzeVar) {
            zze zzeVar2;
            synchronized (zzcnVar) {
                zzeVar2 = zzcnVar.waitersField;
                if (zzeVar2 != zzeVar) {
                    zzcnVar.waitersField = zzeVar;
                }
            }
            return zzeVar2;
        }

        @Override
        final void zzc(zze zzeVar, zze zzeVar2) {
            zzeVar.next = zzeVar2;
        }

        @Override
        final void zzd(zze zzeVar, Thread thread) {
            zzeVar.thread = thread;
        }

        @Override
        final boolean zze(zzcn zzcnVar, zzcm.zzd zzdVar, zzcm.zzd zzdVar2) {
            synchronized (zzcnVar) {
                if (zzcnVar.listenersField != zzdVar) {
                    return false;
                }
                zzcnVar.listenersField = zzdVar2;
                return true;
            }
        }

        @Override
        final boolean zzf(zzcn zzcnVar, Object obj, Object obj2) {
            synchronized (zzcnVar) {
                if (zzcnVar.valueField != obj) {
                    return false;
                }
                zzcnVar.valueField = obj2;
                return true;
            }
        }

        @Override
        final boolean zzg(zzcn zzcnVar, zze zzeVar, zze zzeVar2) {
            synchronized (zzcnVar) {
                if (zzcnVar.waitersField != zzeVar) {
                    return false;
                }
                zzcnVar.waitersField = zzeVar2;
                return true;
            }
        }
    }

    final class zzd extends zza {
        static final Unsafe zza;
        static final long zzb;
        static final long zzc;
        static final long zzd;
        static final long zze;
        static final long zzf;
        public static final int zzg = 0;

        static {
            Unsafe unsafe;
            try {
                try {
                    unsafe = Unsafe.getUnsafe();
                } catch (PrivilegedActionException e) {
                    throw new RuntimeException("Could not initialize intrinsics", e.getCause());
                }
            } catch (SecurityException unused) {
                unsafe = (Unsafe) AccessController.doPrivileged(new PrivilegedExceptionAction() {
                    @Override
                    public final Object run() throws IllegalAccessException {
                        int i = zzcn.zzd.zzg;
                        for (Field field : Unsafe.class.getDeclaredFields()) {
                            field.setAccessible(true);
                            Object obj = field.get(null);
                            if (Unsafe.class.isInstance(obj)) {
                                return (Unsafe) Unsafe.class.cast(obj);
                            }
                        }
                        throw new NoSuchFieldError("the Unsafe");
                    }
                });
            }
            try {
                zzc = unsafe.objectFieldOffset(zzcn.class.getDeclaredField("waitersField"));
                zzb = unsafe.objectFieldOffset(zzcn.class.getDeclaredField("listenersField"));
                zzd = unsafe.objectFieldOffset(zzcn.class.getDeclaredField("valueField"));
                zze = unsafe.objectFieldOffset(zze.class.getDeclaredField("thread"));
                zzf = unsafe.objectFieldOffset(zze.class.getDeclaredField("next"));
                zza = unsafe;
            } catch (NoSuchFieldException e2) {
                throw new RuntimeException(e2);
            }
        }

        private zzd() {
            throw null;
        }

        zzd(zzcr zzcrVar) {
            super(null);
        }

        @Override
        final zzcm.zzd zza(zzcn zzcnVar, zzcm.zzd zzdVar) {
            zzcm.zzd zzdVar2;
            do {
                zzdVar2 = zzcnVar.listenersField;
                if (zzdVar == zzdVar2) {
                    break;
                }
            } while (!zze(zzcnVar, zzdVar2, zzdVar));
            return zzdVar2;
        }

        @Override
        final zze zzb(zzcn zzcnVar, zze zzeVar) {
            zze zzeVar2;
            do {
                zzeVar2 = zzcnVar.waitersField;
                if (zzeVar == zzeVar2) {
                    break;
                }
            } while (!zzg(zzcnVar, zzeVar2, zzeVar));
            return zzeVar2;
        }

        @Override
        final void zzc(zze zzeVar, zze zzeVar2) {
            zza.putObject(zzeVar, zzf, zzeVar2);
        }

        @Override
        final void zzd(zze zzeVar, Thread thread) {
            zza.putObject(zzeVar, zze, thread);
        }

        @Override
        final boolean zze(zzcn zzcnVar, zzcm.zzd zzdVar, zzcm.zzd zzdVar2) {
            return zzcp.zza(zza, zzcnVar, zzb, zzdVar, zzdVar2);
        }

        @Override
        final boolean zzf(zzcn zzcnVar, Object obj, Object obj2) {
            return zzcp.zza(zza, zzcnVar, zzd, obj, obj2);
        }

        @Override
        final boolean zzg(zzcn zzcnVar, zze zzeVar, zze zzeVar2) {
            return zzcp.zza(zza, zzcnVar, zzc, zzeVar, zzeVar2);
        }
    }

    final class zze {
        static final zze zza = new zze(false);
        volatile zze next;
        volatile Thread thread;

        zze() {
            zzcn.zzn(this, Thread.currentThread());
        }

        zze(boolean z) {
        }
    }

    static {
        boolean z;
        Throwable th;
        Throwable th2;
        zza zzcVar;
        try {
            z = Boolean.parseBoolean(System.getProperty("guava.concurrent.generate_cancellation_cause", "false"));
        } catch (SecurityException unused) {
            z = false;
        }
        zzc = z;
        String property = System.getProperty("java.runtime.name", "");
        zzcr zzcrVar = null;
        if (property == null || property.contains("Android")) {
            try {
                zzcVar = new zzd(zzcrVar);
            } catch (Error | Exception e) {
                try {
                    th = e;
                    th2 = null;
                    zzcVar = new zzb(zzcrVar);
                } catch (Error | Exception e2) {
                    th = e;
                    th2 = e2;
                    zzcVar = new zzc(zzcrVar);
                }
            }
        } else {
            try {
                zzcVar = new zzb(zzcrVar);
            } catch (NoClassDefFoundError unused2) {
                zzcVar = new zzc(zzcrVar);
            }
        }
        th2 = null;
        th = null;
        zzd = zzcVar;
        if (th2 != null) {
            zzdb zzdbVar = zzb;
            zzdbVar.zza().logp(Level.SEVERE, "com.google.common.util.concurrent.AbstractFutureState", "<clinit>", "UnsafeAtomicHelper is broken!", th);
            zzdbVar.zza().logp(Level.SEVERE, "com.google.common.util.concurrent.AbstractFutureState", "<clinit>", "AtomicReferenceFieldUpdaterAtomicHelper is broken!", th2);
        }
    }

    zzcn() {
    }

    private final void zza(zze zzeVar) {
        zzeVar.thread = null;
        while (true) {
            zze zzeVar2 = this.waitersField;
            if (zzeVar2 != zze.zza) {
                zze zzeVar3 = null;
                while (zzeVar2 != null) {
                    zze zzeVar4 = zzeVar2.next;
                    if (zzeVar2.thread != null) {
                        zzeVar3 = zzeVar2;
                    } else if (zzeVar3 != null) {
                        zzeVar3.next = zzeVar4;
                        if (zzeVar3.thread == null) {
                        }
                    } else if (!zzd.zzg(this, zzeVar2, zzeVar4)) {
                    }
                    zzeVar2 = zzeVar4;
                }
                return;
            }
            return;
        }
    }

    static void zzn(zze zzeVar, Thread thread) {
        zzd.zzd(zzeVar, thread);
    }

    static boolean zzq(zzcn zzcnVar, Object obj, Object obj2) {
        return zzd.zzf(zzcnVar, obj, obj2);
    }

    final zzcm.zzd zzk(zzcm.zzd zzdVar) {
        return zzd.zza(this, zzdVar);
    }

    final Object zzl() throws ExecutionException, InterruptedException {
        Object obj;
        if (Thread.interrupted()) {
            throw new InterruptedException();
        }
        Object obj2 = this.valueField;
        if ((obj2 != null) && zzcm.zzh(obj2)) {
            return zzcm.zzc(obj2);
        }
        zze zzeVar = this.waitersField;
        if (zzeVar != zze.zza) {
            zze zzeVar2 = new zze();
            do {
                zza zzaVar = zzd;
                zzaVar.zzc(zzeVar2, zzeVar);
                if (zzaVar.zzg(this, zzeVar, zzeVar2)) {
                    do {
                        LockSupport.park(this);
                        if (Thread.interrupted()) {
                            zza(zzeVar2);
                            throw new InterruptedException();
                        }
                        obj = this.valueField;
                    } while (!((obj != null) & zzcm.zzh(obj)));
                    return zzcm.zzc(obj);
                }
                zzeVar = this.waitersField;
            } while (zzeVar != zze.zza);
        }
        return zzcm.zzc(Objects.requireNonNull(this.valueField));
    }

    final Object zzm(long j, TimeUnit timeUnit) throws ExecutionException, InterruptedException, TimeoutException {
        long nanos = timeUnit.toNanos(j);
        if (Thread.interrupted()) {
            throw new InterruptedException();
        }
        Object obj = this.valueField;
        boolean z = true;
        if ((obj != null) && zzcm.zzh(obj)) {
            return zzcm.zzc(obj);
        }
        long jNanoTime = nanos > 0 ? System.nanoTime() + nanos : 0L;
        if (nanos >= 1000) {
            zze zzeVar = this.waitersField;
            if (zzeVar != zze.zza) {
                zze zzeVar2 = new zze();
                while (true) {
                    zza zzaVar = zzd;
                    zzaVar.zzc(zzeVar2, zzeVar);
                    if (zzaVar.zzg(this, zzeVar, zzeVar2)) {
                        do {
                            LockSupport.parkNanos(this, Math.min(nanos, 2147483647999999999L));
                            if (Thread.interrupted()) {
                                zza(zzeVar2);
                                throw new InterruptedException();
                            }
                            Object obj2 = this.valueField;
                            if ((obj2 != null) && zzcm.zzh(obj2)) {
                                return zzcm.zzc(obj2);
                            }
                            nanos = jNanoTime - System.nanoTime();
                        } while (nanos >= 1000);
                        zza(zzeVar2);
                        break;
                    }
                    zzeVar = this.waitersField;
                    if (zzeVar == zze.zza) {
                    }
                }
            }
            return zzcm.zzc(Objects.requireNonNull(this.valueField));
        }
        while (nanos > 0) {
            Object obj3 = this.valueField;
            if ((obj3 != null) && zzcm.zzh(obj3)) {
                return zzcm.zzc(obj3);
            }
            if (Thread.interrupted()) {
                throw new InterruptedException();
            }
            nanos = jNanoTime - System.nanoTime();
        }
        String string = toString();
        String lowerCase = timeUnit.toString().toLowerCase(Locale.ROOT);
        String strConcat = "Waited " + j + " " + timeUnit.toString().toLowerCase(Locale.ROOT);
        if (nanos + 1000 < 0) {
            String strConcat2 = strConcat.concat(" (plus ");
            long j2 = -nanos;
            long jConvert = timeUnit.convert(j2, TimeUnit.NANOSECONDS);
            long nanos2 = j2 - timeUnit.toNanos(jConvert);
            if (jConvert != 0 && nanos2 <= 1000) {
                z = false;
            }
            if (jConvert > 0) {
                String strConcat3 = strConcat2 + jConvert + " " + lowerCase;
                if (z) {
                    strConcat3 = strConcat3.concat(",");
                }
                strConcat2 = strConcat3.concat(" ");
            }
            if (z) {
                strConcat2 = strConcat2 + nanos2 + " nanoseconds ";
            }
            strConcat = strConcat2.concat("delay)");
        }
        if (isDone()) {
            throw new TimeoutException(strConcat.concat(" but future completed as timeout expired"));
        }
        throw new TimeoutException(strConcat + " for " + string);
    }

    final void zzo() {
        for (zze zzeVarZzb = zzd.zzb(this, zze.zza); zzeVarZzb != null; zzeVarZzb = zzeVarZzb.next) {
            Thread thread = zzeVarZzb.thread;
            if (thread != null) {
                zzeVarZzb.thread = null;
                LockSupport.unpark(thread);
            }
        }
    }

    final boolean zzp(zzcm.zzd zzdVar, zzcm.zzd zzdVar2) {
        return zzd.zze(this, zzdVar, zzdVar2);
    }
}

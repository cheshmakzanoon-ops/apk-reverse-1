package com.google.android.gms.internal.measurement;

import java.lang.reflect.Field;
import java.nio.Buffer;
import java.nio.ByteOrder;
import java.security.AccessController;
import java.util.logging.Level;
import java.util.logging.Logger;
import sun.misc.Unsafe;

final class zzmg {
    static final boolean zza;
    private static final Unsafe zzb;
    private static final Class<?> zzc;
    private static final boolean zzd;
    private static final boolean zze;
    private static final zzc zzf;
    private static final boolean zzg;
    private static final boolean zzh;
    private static final long zzi;
    private static final long zzj;
    private static final long zzk;
    private static final long zzl;
    private static final long zzm;
    private static final long zzn;
    private static final long zzo;
    private static final long zzp;
    private static final long zzq;
    private static final long zzr;
    private static final long zzs;
    private static final long zzt;
    private static final long zzu;
    private static final long zzv;
    private static final int zzw;

    private static final class zza extends zzc {
        @Override
        public final double zza(Object obj, long j) {
            return Double.longBitsToDouble(zze(obj, j));
        }

        @Override
        public final float zzb(Object obj, long j) {
            return Float.intBitsToFloat(zzd(obj, j));
        }

        zza(Unsafe unsafe) {
            super(unsafe);
        }

        @Override
        public final void zza(Object obj, long j, boolean z) {
            if (zzmg.zza) {
                zzmg.zza(obj, j, z);
            } else {
                zzmg.zzb(obj, j, z);
            }
        }

        @Override
        public final void zza(Object obj, long j, byte b) {
            if (zzmg.zza) {
                zzmg.zzc(obj, j, b);
            } else {
                zzmg.zzd(obj, j, b);
            }
        }

        @Override
        public final void zza(Object obj, long j, double d) {
            zza(obj, j, Double.doubleToLongBits(d));
        }

        @Override
        public final void zza(Object obj, long j, float f) {
            zza(obj, j, Float.floatToIntBits(f));
        }

        @Override
        public final boolean zzc(Object obj, long j) {
            if (zzmg.zza) {
                return zzmg.zzf(obj, j);
            }
            return zzmg.zzg(obj, j);
        }
    }

    private static final class zzb extends zzc {
        @Override
        public final double zza(Object obj, long j) {
            return Double.longBitsToDouble(zze(obj, j));
        }

        @Override
        public final float zzb(Object obj, long j) {
            return Float.intBitsToFloat(zzd(obj, j));
        }

        zzb(Unsafe unsafe) {
            super(unsafe);
        }

        @Override
        public final void zza(Object obj, long j, boolean z) {
            if (zzmg.zza) {
                zzmg.zza(obj, j, z);
            } else {
                zzmg.zzb(obj, j, z);
            }
        }

        @Override
        public final void zza(Object obj, long j, byte b) {
            if (zzmg.zza) {
                zzmg.zzc(obj, j, b);
            } else {
                zzmg.zzd(obj, j, b);
            }
        }

        @Override
        public final void zza(Object obj, long j, double d) {
            zza(obj, j, Double.doubleToLongBits(d));
        }

        @Override
        public final void zza(Object obj, long j, float f) {
            zza(obj, j, Float.floatToIntBits(f));
        }

        @Override
        public final boolean zzc(Object obj, long j) {
            if (zzmg.zza) {
                return zzmg.zzf(obj, j);
            }
            return zzmg.zzg(obj, j);
        }
    }

    private static abstract class zzc {
        Unsafe zza;

        public abstract double zza(Object obj, long j);

        public abstract void zza(Object obj, long j, byte b);

        public abstract void zza(Object obj, long j, double d);

        public abstract void zza(Object obj, long j, float f);

        public abstract void zza(Object obj, long j, boolean z);

        public abstract float zzb(Object obj, long j);

        public abstract boolean zzc(Object obj, long j);

        public final int zzd(Object obj, long j) {
            return this.zza.getInt(obj, j);
        }

        public final long zze(Object obj, long j) {
            return this.zza.getLong(obj, j);
        }

        zzc(Unsafe unsafe) {
            this.zza = unsafe;
        }

        public final void zza(Object obj, long j, int i) {
            this.zza.putInt(obj, j, i);
        }

        public final void zza(Object obj, long j, long j2) {
            this.zza.putLong(obj, j, j2);
        }

        public final boolean zza() {
            Unsafe unsafe = this.zza;
            if (unsafe == null) {
                return false;
            }
            try {
                Class<?> cls = unsafe.getClass();
                cls.getMethod("objectFieldOffset", Field.class);
                cls.getMethod("arrayBaseOffset", Class.class);
                cls.getMethod("arrayIndexScale", Class.class);
                cls.getMethod("getInt", Object.class, Long.TYPE);
                cls.getMethod("putInt", Object.class, Long.TYPE, Integer.TYPE);
                cls.getMethod("getLong", Object.class, Long.TYPE);
                Class<?> cls2 = Long.TYPE;
                cls.getMethod("putLong", Object.class, cls2, cls2);
                cls.getMethod("getObject", Object.class, Long.TYPE);
                cls.getMethod("putObject", Object.class, Long.TYPE, Object.class);
                return true;
            } catch (Throwable th) {
                zzmg.zza(th);
                return false;
            }
        }

        public final boolean zzb() {
            Unsafe unsafe = this.zza;
            if (unsafe == null) {
                return false;
            }
            try {
                Class<?> cls = unsafe.getClass();
                cls.getMethod("objectFieldOffset", Field.class);
                cls.getMethod("getLong", Object.class, Long.TYPE);
                return zzmg.zze() != null;
            } catch (Throwable th) {
                zzmg.zza(th);
                return false;
            }
        }
    }

    static double zza(Object obj, long j) {
        return zzf.zza(obj, j);
    }

    static float zzb(Object obj, long j) {
        return zzf.zzb(obj, j);
    }

    private static int zzb(Class<?> cls) {
        if (zzh) {
            return zzf.zza.arrayBaseOffset(cls);
        }
        return -1;
    }

    private static int zzc(Class<?> cls) {
        if (zzh) {
            return zzf.zza.arrayIndexScale(cls);
        }
        return -1;
    }

    static int zzc(Object obj, long j) {
        return zzf.zzd(obj, j);
    }

    static long zzd(Object obj, long j) {
        return zzf.zze(obj, j);
    }

    static <T> T zza(Class<T> cls) {
        try {
            return (T) zzb.allocateInstance(cls);
        } catch (InstantiationException e) {
            throw new IllegalStateException(e);
        }
    }

    static Object zze(Object obj, long j) {
        return zzf.zza.getObject(obj, j);
    }

    public static Field zze() {
        Field fieldZza = zza((Class<?>) Buffer.class, "effectiveDirectAddress");
        if (fieldZza != null) {
            return fieldZza;
        }
        Field fieldZza2 = zza((Class<?>) Buffer.class, "address");
        if (fieldZza2 == null || fieldZza2.getType() != Long.TYPE) {
            return null;
        }
        return fieldZza2;
    }

    private static Field zza(Class<?> cls, String str) {
        try {
            return cls.getDeclaredField(str);
        } catch (Throwable unused) {
            return null;
        }
    }

    static Unsafe zzb() {
        try {
            return (Unsafe) AccessController.doPrivileged(new zzmf());
        } catch (Throwable unused) {
            return null;
        }
    }

    static void zza(Throwable th) {
        Logger.getLogger(zzmg.class.getName()).logp(Level.WARNING, "com.google.protobuf.UnsafeUtil", "logMissingMethod", "platform method missing - proto runtime falling back to safer methods: " + String.valueOf(th));
    }

    static void zza(Object obj, long j, boolean z) {
        zzc(obj, j, z ? (byte) 1 : (byte) 0);
    }

    static void zzb(Object obj, long j, boolean z) {
        zzd(obj, j, z ? (byte) 1 : (byte) 0);
    }

    static {
        zzc zzbVar;
        Unsafe unsafeZzb = zzb();
        zzb = unsafeZzb;
        zzc = zzhj.zza();
        boolean zZzd = zzd(Long.TYPE);
        zzd = zZzd;
        boolean zZzd2 = zzd(Integer.TYPE);
        zze = zZzd2;
        if (unsafeZzb == null) {
            zzbVar = null;
        } else if (zZzd) {
            zzbVar = new zza(unsafeZzb);
        } else if (zZzd2) {
            zzbVar = new zzb(unsafeZzb);
        } else {
            zzbVar = null;
        }
        zzf = zzbVar;
        zzg = zzbVar == null ? false : zzbVar.zzb();
        zzh = zzbVar == null ? false : zzbVar.zza();
        long jZzb = zzb(byte[].class);
        zzi = jZzb;
        zzj = zzb(boolean[].class);
        zzk = zzc(boolean[].class);
        zzl = zzb(int[].class);
        zzm = zzc(int[].class);
        zzn = zzb(long[].class);
        zzo = zzc(long[].class);
        zzp = zzb(float[].class);
        zzq = zzc(float[].class);
        zzr = zzb(double[].class);
        zzs = zzc(double[].class);
        zzt = zzb(Object[].class);
        zzu = zzc(Object[].class);
        Field fieldZze = zze();
        zzv = (fieldZze == null || zzbVar == null) ? -1L : zzbVar.zza.objectFieldOffset(fieldZze);
        zzw = (int) (jZzb & 7);
        zza = ByteOrder.nativeOrder() == ByteOrder.BIG_ENDIAN;
    }

    private zzmg() {
    }

    static void zzc(Object obj, long j, boolean z) {
        zzf.zza(obj, j, z);
    }

    static void zza(byte[] bArr, long j, byte b) {
        zzf.zza((Object) bArr, zzi + j, b);
    }

    public static void zzc(Object obj, long j, byte b) {
        long j2 = (-4) & j;
        int iZzc = zzc(obj, j2);
        int i = ((~((int) j)) & 3) << 3;
        zza(obj, j2, ((255 & b) << i) | (iZzc & (~(255 << i))));
    }

    public static void zzd(Object obj, long j, byte b) {
        long j2 = (-4) & j;
        int i = (((int) j) & 3) << 3;
        zza(obj, j2, ((255 & b) << i) | (zzc(obj, j2) & (~(255 << i))));
    }

    static void zza(Object obj, long j, double d) {
        zzf.zza(obj, j, d);
    }

    static void zza(Object obj, long j, float f) {
        zzf.zza(obj, j, f);
    }

    static void zza(Object obj, long j, int i) {
        zzf.zza(obj, j, i);
    }

    static void zza(Object obj, long j, long j2) {
        zzf.zza(obj, j, j2);
    }

    static void zza(Object obj, long j, Object obj2) {
        zzf.zza.putObject(obj, j, obj2);
    }

    static boolean zzf(Object obj, long j) {
        return ((byte) (zzc(obj, (-4) & j) >>> ((int) (((~j) & 3) << 3)))) != 0;
    }

    static boolean zzg(Object obj, long j) {
        return ((byte) (zzc(obj, (-4) & j) >>> ((int) ((j & 3) << 3)))) != 0;
    }

    private static boolean zzd(Class<?> cls) {
        try {
            Class<?> cls2 = zzc;
            cls2.getMethod("peekLong", cls, Boolean.TYPE);
            cls2.getMethod("pokeLong", cls, Long.TYPE, Boolean.TYPE);
            cls2.getMethod("pokeInt", cls, Integer.TYPE, Boolean.TYPE);
            cls2.getMethod("peekInt", cls, Boolean.TYPE);
            cls2.getMethod("pokeByte", cls, Byte.TYPE);
            cls2.getMethod("peekByte", cls);
            Class<?> cls3 = Integer.TYPE;
            cls2.getMethod("pokeByteArray", cls, byte[].class, cls3, cls3);
            Class<?> cls4 = Integer.TYPE;
            cls2.getMethod("peekByteArray", cls, byte[].class, cls4, cls4);
            return true;
        } catch (Throwable unused) {
            return false;
        }
    }

    static boolean zzh(Object obj, long j) {
        return zzf.zzc(obj, j);
    }

    static boolean zzc() {
        return zzh;
    }

    static boolean zzd() {
        return zzg;
    }
}

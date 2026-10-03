package com.google.android.gms.measurement.internal;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ResolveInfo;
import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.internal.safeparcel.AbstractSafeParcelable;
import com.google.android.gms.common.stats.ConnectionTracker;
import com.google.android.gms.common.util.Clock;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.atomic.AtomicReference;
import org.checkerframework.dataflow.qual.Pure;

public final class zzkp extends zze {
    private final zzlm zza;
    private zzfk zzb;
    private volatile Boolean zzc;
    private final zzaw zzd;
    private final zzmi zze;
    private final List<Runnable> zzf;
    private final zzaw zzg;

    @Override
    @Pure
    public final Context zza() {
        return super.zza();
    }

    @Override
    protected final boolean zzz() {
        return false;
    }

    @Override
    @Pure
    public final Clock zzb() {
        return super.zzb();
    }

    @Override
    public final zzb zzc() {
        return super.zzc();
    }

    private final zzo zzb(boolean z) {
        return zzg().zza(z ? zzj().zzx() : null);
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

    protected final zzam zzaa() {
        zzt();
        zzu();
        zzfk zzfkVar = this.zzb;
        if (zzfkVar == null) {
            zzad();
            zzj().zzc().zza("Failed to get consents; not connected to service yet.");
            return null;
        }
        zzo zzoVarZzb = zzb(false);
        Preconditions.checkNotNull(zzoVarZzb);
        try {
            zzam zzamVarZza = zzfkVar.zza(zzoVarZzb);
            zzal();
            return zzamVarZza;
        } catch (RemoteException e) {
            zzj().zzg().zza("Failed to get consents; remote exception", e);
            return null;
        }
    }

    @Override
    @Pure
    public final zzba zzf() {
        return super.zzf();
    }

    @Override
    public final zzfl zzg() {
        return super.zzg();
    }

    @Override
    public final zzfo zzh() {
        return super.zzh();
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
    public final zziq zzm() {
        return super.zzm();
    }

    @Override
    public final zzkh zzn() {
        return super.zzn();
    }

    @Override
    public final zzkp zzo() {
        return super.zzo();
    }

    @Override
    public final zzlx zzp() {
        return super.zzp();
    }

    @Override
    @Pure
    public final zznd zzq() {
        return super.zzq();
    }

    final Boolean zzab() {
        return this.zzc;
    }

    static void zzd(zzkp zzkpVar) {
        zzkpVar.zzt();
        if (zzkpVar.zzah()) {
            zzkpVar.zzj().zzp().zza("Inactivity, disconnecting from the service");
            zzkpVar.zzae();
        }
    }

    static void zza(zzkp zzkpVar, ComponentName componentName) {
        zzkpVar.zzt();
        if (zzkpVar.zzb != null) {
            zzkpVar.zzb = null;
            zzkpVar.zzj().zzp().zza("Disconnected from device MeasurementService", componentName);
            zzkpVar.zzt();
            zzkpVar.zzad();
        }
    }

    protected zzkp(zzhf zzhfVar) {
        super(zzhfVar);
        this.zzf = new ArrayList();
        this.zze = new zzmi(zzhfVar.zzb());
        this.zza = new zzlm(this);
        this.zzd = new zzks(this, zzhfVar);
        this.zzg = new zzlb(this, zzhfVar);
    }

    protected final void zzac() {
        zzt();
        zzu();
        zzo zzoVarZzb = zzb(true);
        zzh().zzab();
        zza(new zzla(this, zzoVarZzb));
    }

    @Override
    public final void zzr() {
        super.zzr();
    }

    @Override
    public final void zzs() {
        super.zzs();
    }

    @Override
    public final void zzt() {
        super.zzt();
    }

    final void zzad() {
        zzt();
        zzu();
        if (zzah()) {
            return;
        }
        if (zzam()) {
            this.zza.zza();
            return;
        }
        if (zze().zzw()) {
            return;
        }
        List<ResolveInfo> listQueryIntentServices = zza().getPackageManager().queryIntentServices(new Intent().setClassName(zza(), "com.google.android.gms.measurement.AppMeasurementService"), 65536);
        if (listQueryIntentServices != null && !listQueryIntentServices.isEmpty()) {
            Intent intent = new Intent("com.google.android.gms.measurement.START");
            intent.setComponent(new ComponentName(zza(), "com.google.android.gms.measurement.AppMeasurementService"));
            this.zza.zza(intent);
            return;
        }
        zzj().zzg().zza("Unable to use remote or local measurement implementation. Please register the AppMeasurementService service in the app manifest");
    }

    public final void zzae() {
        zzt();
        zzu();
        this.zza.zzb();
        try {
            ConnectionTracker.getInstance().unbindService(zza(), this.zza);
        } catch (IllegalArgumentException | IllegalStateException unused) {
        }
        this.zzb = null;
    }

    public final void zzak() {
        zzt();
        zzj().zzp().zza("Processing queued up service tasks", Integer.valueOf(this.zzf.size()));
        Iterator<Runnable> it = this.zzf.iterator();
        while (it.hasNext()) {
            try {
                it.next().run();
            } catch (RuntimeException e) {
                zzj().zzg().zza("Task exception while flushing queue", e);
            }
        }
        this.zzf.clear();
        this.zzg.zza();
    }

    public final void zza(com.google.android.gms.internal.measurement.zzcv zzcvVar) {
        zzt();
        zzu();
        zza(new zzkx(this, zzb(false), zzcvVar));
    }

    public final void zza(AtomicReference<String> atomicReference) {
        zzt();
        zzu();
        zza(new zzky(this, atomicReference, zzb(false)));
    }

    protected final void zza(com.google.android.gms.internal.measurement.zzcv zzcvVar, String str, String str2) {
        zzt();
        zzu();
        zza(new zzlk(this, str, str2, zzb(false), zzcvVar));
    }

    protected final void zza(AtomicReference<List<zzad>> atomicReference, String str, String str2, String str3) {
        zzt();
        zzu();
        zza(new zzlh(this, atomicReference, str, str2, str3, zzb(false)));
    }

    protected final void zza(AtomicReference<List<zzmh>> atomicReference, Bundle bundle) {
        zzt();
        zzu();
        zza(new zzkt(this, atomicReference, zzb(false), bundle));
    }

    protected final void zza(AtomicReference<List<zznc>> atomicReference, boolean z) {
        zzt();
        zzu();
        zza(new zzku(this, atomicReference, zzb(false), z));
    }

    protected final void zza(com.google.android.gms.internal.measurement.zzcv zzcvVar, String str, String str2, boolean z) {
        zzt();
        zzu();
        zza(new zzkr(this, str, str2, zzb(false), z, zzcvVar));
    }

    protected final void zza(AtomicReference<List<zznc>> atomicReference, String str, String str2, String str3, boolean z) {
        zzt();
        zzu();
        zza(new zzlj(this, atomicReference, str, str2, str3, zzb(false), z));
    }

    protected final void zza(zzbg zzbgVar, String str) {
        Preconditions.checkNotNull(zzbgVar);
        zzt();
        zzu();
        zza(new zzlf(this, true, zzb(true), zzh().zza(zzbgVar), zzbgVar, str));
    }

    public final void zza(com.google.android.gms.internal.measurement.zzcv zzcvVar, zzbg zzbgVar, String str) {
        zzt();
        zzu();
        if (zzq().zza(12451000) != 0) {
            zzj().zzu().zza("Not bundling data. Service unavailable or out of date");
            zzq().zza(zzcvVar, new byte[0]);
        } else {
            zza(new zzle(this, zzbgVar, str, zzcvVar));
        }
    }

    public final void zzal() {
        zzt();
        this.zze.zzb();
        this.zzd.zza(zzbi.zzaj.zza(null).longValue());
    }

    protected final void zzaf() {
        zzt();
        zzu();
        zzo zzoVarZzb = zzb(false);
        zzh().zzaa();
        zza(new zzkv(this, zzoVarZzb));
    }

    private final void zza(Runnable runnable) throws IllegalStateException {
        zzt();
        if (zzah()) {
            runnable.run();
        } else {
            if (this.zzf.size() >= 1000) {
                zzj().zzg().zza("Discarding data. Max runnable queue size reached");
                return;
            }
            this.zzf.add(runnable);
            this.zzg.zza(60000L);
            zzad();
        }
    }

    final void zza(zzfk zzfkVar, AbstractSafeParcelable abstractSafeParcelable, zzo zzoVar) throws Throwable {
        int size;
        zzt();
        zzu();
        int i = 100;
        int i2 = 0;
        while (i2 < 1001 && i == 100) {
            ArrayList arrayList = new ArrayList();
            List<AbstractSafeParcelable> listZza = zzh().zza(100);
            if (listZza != null) {
                arrayList.addAll(listZza);
                size = listZza.size();
            } else {
                size = 0;
            }
            if (abstractSafeParcelable != null && size < 100) {
                arrayList.add(abstractSafeParcelable);
            }
            int size2 = arrayList.size();
            int i3 = 0;
            while (i3 < size2) {
                Object obj = arrayList.get(i3);
                i3++;
                AbstractSafeParcelable abstractSafeParcelable2 = (AbstractSafeParcelable) obj;
                if (abstractSafeParcelable2 instanceof zzbg) {
                    try {
                        zzfkVar.zza((zzbg) abstractSafeParcelable2, zzoVar);
                    } catch (RemoteException e) {
                        zzj().zzg().zza("Failed to send event to the service", e);
                    }
                } else if (abstractSafeParcelable2 instanceof zznc) {
                    try {
                        zzfkVar.zza((zznc) abstractSafeParcelable2, zzoVar);
                    } catch (RemoteException e2) {
                        zzj().zzg().zza("Failed to send user property to the service", e2);
                    }
                } else if (abstractSafeParcelable2 instanceof zzad) {
                    try {
                        zzfkVar.zza((zzad) abstractSafeParcelable2, zzoVar);
                    } catch (RemoteException e3) {
                        zzj().zzg().zza("Failed to send conditional user property to the service", e3);
                    }
                } else {
                    zzj().zzg().zza("Discarding data. Unrecognized parcel type.");
                }
            }
            i2++;
            i = size;
        }
    }

    protected final void zza(zzad zzadVar) {
        Preconditions.checkNotNull(zzadVar);
        zzt();
        zzu();
        zza(new zzli(this, true, zzb(true), zzh().zza(zzadVar), new zzad(zzadVar), zzadVar));
    }

    protected final void zza(boolean z) {
        zzt();
        zzu();
        if (z) {
            zzh().zzaa();
        }
        if (zzaj()) {
            zza(new zzlg(this, zzb(false)));
        }
    }

    protected final void zza(zzki zzkiVar) {
        zzt();
        zzu();
        zza(new zzkz(this, zzkiVar));
    }

    public final void zza(Bundle bundle) {
        zzt();
        zzu();
        zza(new zzlc(this, zzb(false), bundle));
    }

    protected final void zzag() {
        zzt();
        zzu();
        zza(new zzld(this, zzb(true)));
    }

    protected final void zza(zzfk zzfkVar) {
        zzt();
        Preconditions.checkNotNull(zzfkVar);
        this.zzb = zzfkVar;
        zzal();
        zzak();
    }

    protected final void zza(zznc zzncVar) {
        zzt();
        zzu();
        zza(new zzkw(this, zzb(true), zzh().zza(zzncVar), zzncVar));
    }

    public final boolean zzah() {
        zzt();
        zzu();
        return this.zzb != null;
    }

    final boolean zzai() {
        zzt();
        zzu();
        return !zzam() || zzq().zzg() >= 200900;
    }

    final boolean zzaj() {
        zzt();
        zzu();
        return !zzam() || zzq().zzg() >= zzbi.zzbo.zza(null).intValue();
    }

    private final boolean zzam() {
        boolean z;
        zzt();
        zzu();
        if (this.zzc == null) {
            zzt();
            zzu();
            Boolean boolZzn = zzk().zzn();
            boolean z2 = true;
            if (boolZzn == null || !boolZzn.booleanValue()) {
                boolean z3 = false;
                if (zzg().zzaa() == 1) {
                    z = true;
                } else {
                    zzj().zzp().zza("Checking service availability");
                    int iZza = zzq().zza(12451000);
                    if (iZza != 0) {
                        if (iZza == 1) {
                            zzj().zzp().zza("Service missing");
                        } else if (iZza != 2) {
                            if (iZza == 3) {
                                zzj().zzu().zza("Service disabled");
                            } else if (iZza == 9) {
                                zzj().zzu().zza("Service invalid");
                            } else if (iZza == 18) {
                                zzj().zzu().zza("Service updating");
                            } else {
                                zzj().zzu().zza("Unexpected service status", Integer.valueOf(iZza));
                            }
                            z = false;
                            z2 = false;
                        } else {
                            zzj().zzc().zza("Service container out of date");
                            if (zzq().zzg() >= 17443) {
                                z2 = boolZzn == null;
                                z = false;
                            }
                        }
                        z = true;
                        z2 = false;
                    } else {
                        zzj().zzp().zza("Service available");
                    }
                    z = true;
                }
                if (z2 || !zze().zzw()) {
                    z3 = z;
                } else {
                    zzj().zzg().zza("No way to upload. Consider using the full version of Analytics");
                }
                if (z3) {
                    zzk().zza(z2);
                }
            }
            this.zzc = Boolean.valueOf(z2);
        }
        return this.zzc.booleanValue();
    }
}

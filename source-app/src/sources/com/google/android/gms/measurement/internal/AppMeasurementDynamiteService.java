package com.google.android.gms.measurement.internal;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.RemoteException;
import android.text.TextUtils;
import androidx.collection.ArrayMap;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.dynamic.IObjectWrapper;
import com.google.android.gms.dynamic.ObjectWrapper;
import java.util.Map;
import org.checkerframework.checker.nullness.qual.EnsuresNonNull;

public class AppMeasurementDynamiteService extends com.google.android.gms.internal.measurement.zzct {
    zzhf zza = null;
    private final Map<Integer, zzil> zzb = new ArrayMap();

    class zza implements zzim {
        private com.google.android.gms.internal.measurement.zzda zza;

        zza(com.google.android.gms.internal.measurement.zzda zzdaVar) {
            this.zza = zzdaVar;
        }

        @Override
        public final void interceptEvent(String str, String str2, Bundle bundle, long j) {
            try {
                this.zza.zza(str, str2, bundle, j);
            } catch (RemoteException e) {
                if (AppMeasurementDynamiteService.this.zza != null) {
                    AppMeasurementDynamiteService.this.zza.zzj().zzu().zza("Event interceptor threw exception", e);
                }
            }
        }
    }

    class zzb implements zzil {
        private com.google.android.gms.internal.measurement.zzda zza;

        zzb(com.google.android.gms.internal.measurement.zzda zzdaVar) {
            this.zza = zzdaVar;
        }

        @Override
        public final void onEvent(String str, String str2, Bundle bundle, long j) {
            try {
                this.zza.zza(str, str2, bundle, j);
            } catch (RemoteException e) {
                if (AppMeasurementDynamiteService.this.zza != null) {
                    AppMeasurementDynamiteService.this.zza.zzj().zzu().zza("Event listener threw exception", e);
                }
            }
        }
    }

    @Override
    public void beginAdUnitExposure(String str, long j) throws RemoteException {
        zza();
        this.zza.zze().zza(str, j);
    }

    @EnsuresNonNull({"scion"})
    private final void zza() {
        if (this.zza == null) {
            throw new IllegalStateException("Attempting to perform action before initialize.");
        }
    }

    @Override
    public void clearConditionalUserProperty(String str, String str2, Bundle bundle) throws RemoteException {
        zza();
        this.zza.zzp().zza(str, str2, bundle);
    }

    @Override
    public void clearMeasurementEnabled(long j) throws RemoteException {
        zza();
        this.zza.zzp().zza((Boolean) null);
    }

    @Override
    public void endAdUnitExposure(String str, long j) throws RemoteException {
        zza();
        this.zza.zze().zzb(str, j);
    }

    @Override
    public void generateEventId(com.google.android.gms.internal.measurement.zzcv zzcvVar) throws RemoteException {
        zza();
        long jZzm = this.zza.zzt().zzm();
        zza();
        this.zza.zzt().zza(zzcvVar, jZzm);
    }

    @Override
    public void getAppInstanceId(com.google.android.gms.internal.measurement.zzcv zzcvVar) throws RemoteException {
        zza();
        this.zza.zzl().zzb(new zzi(this, zzcvVar));
    }

    @Override
    public void getCachedAppInstanceId(com.google.android.gms.internal.measurement.zzcv zzcvVar) throws RemoteException {
        zza();
        zza(zzcvVar, this.zza.zzp().zzae());
    }

    @Override
    public void getConditionalUserProperties(String str, String str2, com.google.android.gms.internal.measurement.zzcv zzcvVar) throws RemoteException {
        zza();
        this.zza.zzl().zzb(new zzl(this, zzcvVar, str, str2));
    }

    @Override
    public void getCurrentScreenClass(com.google.android.gms.internal.measurement.zzcv zzcvVar) throws RemoteException {
        zza();
        zza(zzcvVar, this.zza.zzp().zzaf());
    }

    @Override
    public void getCurrentScreenName(com.google.android.gms.internal.measurement.zzcv zzcvVar) throws RemoteException {
        zza();
        zza(zzcvVar, this.zza.zzp().zzag());
    }

    @Override
    public void getGmpAppId(com.google.android.gms.internal.measurement.zzcv zzcvVar) throws RemoteException {
        zza();
        zza(zzcvVar, this.zza.zzp().zzah());
    }

    @Override
    public void getMaxUserProperties(String str, com.google.android.gms.internal.measurement.zzcv zzcvVar) throws RemoteException {
        zza();
        this.zza.zzp();
        Preconditions.checkNotEmpty(str);
        zza();
        this.zza.zzt().zza(zzcvVar, 25);
    }

    @Override
    public void getSessionId(com.google.android.gms.internal.measurement.zzcv zzcvVar) throws RemoteException {
        zza();
        zziq zziqVarZzp = this.zza.zzp();
        zziqVarZzp.zzl().zzb(new zzjq(zziqVarZzp, zzcvVar));
    }

    @Override
    public void getTestFlag(com.google.android.gms.internal.measurement.zzcv zzcvVar, int i) throws RemoteException {
        zza();
        if (i == 0) {
            this.zza.zzt().zza(zzcvVar, this.zza.zzp().zzai());
            return;
        }
        if (i == 1) {
            this.zza.zzt().zza(zzcvVar, this.zza.zzp().zzad().longValue());
            return;
        }
        if (i != 2) {
            if (i == 3) {
                this.zza.zzt().zza(zzcvVar, this.zza.zzp().zzac().intValue());
                return;
            } else {
                if (i != 4) {
                    return;
                }
                this.zza.zzt().zza(zzcvVar, this.zza.zzp().zzaa().booleanValue());
                return;
            }
        }
        zznd zzndVarZzt = this.zza.zzt();
        double dDoubleValue = this.zza.zzp().zzab().doubleValue();
        Bundle bundle = new Bundle();
        bundle.putDouble("r", dDoubleValue);
        try {
            zzcvVar.zza(bundle);
        } catch (RemoteException e) {
            zzndVarZzt.zzu.zzj().zzu().zza("Error returning double value to wrapper", e);
        }
    }

    @Override
    public void getUserProperties(String str, String str2, boolean z, com.google.android.gms.internal.measurement.zzcv zzcvVar) throws RemoteException {
        zza();
        this.zza.zzl().zzb(new zzj(this, zzcvVar, str, str2, z));
    }

    @Override
    public void initForTests(Map map) throws RemoteException {
        zza();
    }

    @Override
    public void initialize(IObjectWrapper iObjectWrapper, com.google.android.gms.internal.measurement.zzdd zzddVar, long j) throws RemoteException {
        zzhf zzhfVar = this.zza;
        if (zzhfVar == null) {
            this.zza = zzhf.zza((Context) Preconditions.checkNotNull((Context) ObjectWrapper.unwrap(iObjectWrapper)), zzddVar, Long.valueOf(j));
        } else {
            zzhfVar.zzj().zzu().zza("Attempting to initialize multiple times");
        }
    }

    @Override
    public void isDataCollectionEnabled(com.google.android.gms.internal.measurement.zzcv zzcvVar) throws RemoteException {
        zza();
        this.zza.zzl().zzb(new zzn(this, zzcvVar));
    }

    @Override
    public void logEvent(String str, String str2, Bundle bundle, boolean z, boolean z2, long j) throws RemoteException {
        zza();
        this.zza.zzp().zza(str, str2, bundle, z, z2, j);
    }

    @Override
    public void logEventAndBundle(String str, String str2, Bundle bundle, com.google.android.gms.internal.measurement.zzcv zzcvVar, long j) throws RemoteException {
        zza();
        Preconditions.checkNotEmpty(str2);
        (bundle != null ? new Bundle(bundle) : new Bundle()).putString("_o", "app");
        this.zza.zzl().zzb(new zzk(this, zzcvVar, new zzbg(str2, new zzbb(bundle), "app", j), str));
    }

    @Override
    public void logHealthData(int i, String str, IObjectWrapper iObjectWrapper, IObjectWrapper iObjectWrapper2, IObjectWrapper iObjectWrapper3) throws RemoteException {
        zza();
        this.zza.zzj().zza(i, true, false, str, iObjectWrapper == null ? null : ObjectWrapper.unwrap(iObjectWrapper), iObjectWrapper2 == null ? null : ObjectWrapper.unwrap(iObjectWrapper2), iObjectWrapper3 != null ? ObjectWrapper.unwrap(iObjectWrapper3) : null);
    }

    @Override
    public void onActivityCreated(IObjectWrapper iObjectWrapper, Bundle bundle, long j) throws RemoteException {
        zza();
        zzjx zzjxVar = this.zza.zzp().zza;
        if (zzjxVar != null) {
            this.zza.zzp().zzak();
            zzjxVar.onActivityCreated((Activity) ObjectWrapper.unwrap(iObjectWrapper), bundle);
        }
    }

    @Override
    public void onActivityDestroyed(IObjectWrapper iObjectWrapper, long j) throws RemoteException {
        zza();
        zzjx zzjxVar = this.zza.zzp().zza;
        if (zzjxVar != null) {
            this.zza.zzp().zzak();
            zzjxVar.onActivityDestroyed((Activity) ObjectWrapper.unwrap(iObjectWrapper));
        }
    }

    @Override
    public void onActivityPaused(IObjectWrapper iObjectWrapper, long j) throws RemoteException {
        zza();
        zzjx zzjxVar = this.zza.zzp().zza;
        if (zzjxVar != null) {
            this.zza.zzp().zzak();
            zzjxVar.onActivityPaused((Activity) ObjectWrapper.unwrap(iObjectWrapper));
        }
    }

    @Override
    public void onActivityResumed(IObjectWrapper iObjectWrapper, long j) throws RemoteException {
        zza();
        zzjx zzjxVar = this.zza.zzp().zza;
        if (zzjxVar != null) {
            this.zza.zzp().zzak();
            zzjxVar.onActivityResumed((Activity) ObjectWrapper.unwrap(iObjectWrapper));
        }
    }

    @Override
    public void onActivitySaveInstanceState(IObjectWrapper iObjectWrapper, com.google.android.gms.internal.measurement.zzcv zzcvVar, long j) throws RemoteException {
        zza();
        zzjx zzjxVar = this.zza.zzp().zza;
        Bundle bundle = new Bundle();
        if (zzjxVar != null) {
            this.zza.zzp().zzak();
            zzjxVar.onActivitySaveInstanceState((Activity) ObjectWrapper.unwrap(iObjectWrapper), bundle);
        }
        try {
            zzcvVar.zza(bundle);
        } catch (RemoteException e) {
            this.zza.zzj().zzu().zza("Error returning bundle value to wrapper", e);
        }
    }

    @Override
    public void onActivityStarted(IObjectWrapper iObjectWrapper, long j) throws RemoteException {
        zza();
        zzjx zzjxVar = this.zza.zzp().zza;
        if (zzjxVar != null) {
            this.zza.zzp().zzak();
            zzjxVar.onActivityStarted((Activity) ObjectWrapper.unwrap(iObjectWrapper));
        }
    }

    @Override
    public void onActivityStopped(IObjectWrapper iObjectWrapper, long j) throws RemoteException {
        zza();
        zzjx zzjxVar = this.zza.zzp().zza;
        if (zzjxVar != null) {
            this.zza.zzp().zzak();
            zzjxVar.onActivityStopped((Activity) ObjectWrapper.unwrap(iObjectWrapper));
        }
    }

    @Override
    public void performAction(Bundle bundle, com.google.android.gms.internal.measurement.zzcv zzcvVar, long j) throws RemoteException {
        zza();
        zzcvVar.zza(null);
    }

    @Override
    public void registerOnMeasurementEventListener(com.google.android.gms.internal.measurement.zzda zzdaVar) throws RemoteException {
        zzil zzbVar;
        zza();
        synchronized (this.zzb) {
            zzbVar = this.zzb.get(Integer.valueOf(zzdaVar.zza()));
            if (zzbVar == null) {
                zzbVar = new zzb(zzdaVar);
                this.zzb.put(Integer.valueOf(zzdaVar.zza()), zzbVar);
            }
        }
        this.zza.zzp().zza(zzbVar);
    }

    @Override
    public void resetAnalyticsData(long j) throws RemoteException {
        zza();
        zziq zziqVarZzp = this.zza.zzp();
        zziqVarZzp.zza((String) null);
        zziqVarZzp.zzl().zzb(new zzjk(zziqVarZzp, j));
    }

    private final void zza(com.google.android.gms.internal.measurement.zzcv zzcvVar, String str) {
        zza();
        this.zza.zzt().zza(zzcvVar, str);
    }

    @Override
    public void setConditionalUserProperty(Bundle bundle, long j) throws RemoteException {
        zza();
        if (bundle == null) {
            this.zza.zzj().zzg().zza("Conditional user property must not be null");
        } else {
            this.zza.zzp().zza(bundle, j);
        }
    }

    @Override
    public void setConsent(final Bundle bundle, final long j) throws RemoteException {
        zza();
        final zziq zziqVarZzp = this.zza.zzp();
        zziqVarZzp.zzl().zzc(new Runnable() {
            @Override
            public final void run() {
                zziq zziqVar = zziqVarZzp;
                Bundle bundle2 = bundle;
                long j2 = j;
                if (TextUtils.isEmpty(zziqVar.zzg().zzae())) {
                    zziqVar.zza(bundle2, 0, j2);
                } else {
                    zziqVar.zzj().zzv().zza("Using developer consent only; google app id found");
                }
            }
        });
    }

    @Override
    public void setConsentThirdParty(Bundle bundle, long j) throws RemoteException {
        zza();
        this.zza.zzp().zza(bundle, -20, j);
    }

    @Override
    public void setCurrentScreen(IObjectWrapper iObjectWrapper, String str, String str2, long j) throws RemoteException {
        zza();
        this.zza.zzq().zza((Activity) ObjectWrapper.unwrap(iObjectWrapper), str, str2);
    }

    @Override
    public void setDataCollectionEnabled(boolean z) throws RemoteException {
        zza();
        zziq zziqVarZzp = this.zza.zzp();
        zziqVarZzp.zzu();
        zziqVarZzp.zzl().zzb(new zzjb(zziqVarZzp, z));
    }

    @Override
    public void setDefaultEventParameters(Bundle bundle) {
        zza();
        final zziq zziqVarZzp = this.zza.zzp();
        final Bundle bundle2 = bundle == null ? null : new Bundle(bundle);
        zziqVarZzp.zzl().zzb(new Runnable() {
            @Override
            public final void run() {
                zziqVarZzp.zza(bundle2);
            }
        });
    }

    @Override
    public void setEventInterceptor(com.google.android.gms.internal.measurement.zzda zzdaVar) throws RemoteException {
        zza();
        zza zzaVar = new zza(zzdaVar);
        if (this.zza.zzl().zzg()) {
            this.zza.zzp().zza(zzaVar);
        } else {
            this.zza.zzl().zzb(new zzm(this, zzaVar));
        }
    }

    @Override
    public void setInstanceIdProvider(com.google.android.gms.internal.measurement.zzdb zzdbVar) throws RemoteException {
        zza();
    }

    @Override
    public void setMeasurementEnabled(boolean z, long j) throws RemoteException {
        zza();
        this.zza.zzp().zza(Boolean.valueOf(z));
    }

    @Override
    public void setMinimumSessionDuration(long j) throws RemoteException {
        zza();
    }

    @Override
    public void setSessionTimeoutDuration(long j) throws RemoteException {
        zza();
        zziq zziqVarZzp = this.zza.zzp();
        zziqVarZzp.zzl().zzb(new zzjd(zziqVarZzp, j));
    }

    @Override
    public void setUserId(final String str, long j) throws RemoteException {
        zza();
        final zziq zziqVarZzp = this.zza.zzp();
        if (str != null && TextUtils.isEmpty(str)) {
            zziqVarZzp.zzu.zzj().zzu().zza("User ID must be non-empty or null");
        } else {
            zziqVarZzp.zzl().zzb(new Runnable() {
                @Override
                public final void run() {
                    zziq zziqVar = zziqVarZzp;
                    if (zziqVar.zzg().zzb(str)) {
                        zziqVar.zzg().zzag();
                    }
                }
            });
            zziqVarZzp.zza((String) null, "_id", (Object) str, true, j);
        }
    }

    @Override
    public void setUserProperty(String str, String str2, IObjectWrapper iObjectWrapper, boolean z, long j) throws RemoteException {
        zza();
        this.zza.zzp().zza(str, str2, ObjectWrapper.unwrap(iObjectWrapper), z, j);
    }

    @Override
    public void unregisterOnMeasurementEventListener(com.google.android.gms.internal.measurement.zzda zzdaVar) throws RemoteException {
        zzil zzilVarRemove;
        zza();
        synchronized (this.zzb) {
            zzilVarRemove = this.zzb.remove(Integer.valueOf(zzdaVar.zza()));
        }
        if (zzilVarRemove == null) {
            zzilVarRemove = new zzb(zzdaVar);
        }
        this.zza.zzp().zzb(zzilVarRemove);
    }
}
